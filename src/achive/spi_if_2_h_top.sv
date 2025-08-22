// Top-level module for spi_if_2 & h_ext
module spi_if_2_h_top (
  input logic [21:0] data_in,
  output logic error_flag,

  input logic sck,
  input logic sdi,
  input logic cs_n,
  output logic sdo,

  output logic [4:0] addr_mem_o,
  output logic en_mem
);

logic [4:0] err_idx;
wire error_flag_net;

h_ext ham (
  .data_in(data_in),
  .err_idx(err_idx),
  .error_flag(error_flag_net)
);

spi_if_2 spi (
  .sck(sck),
  .sdi(sdi),
  .cs_n(cs_n),
  .sdo(sdo),
  .err_flag(error_flag),
  .error_flag_i(error_flag_net),
  .data_mem_i({data_in[21], data_in[20], data_in[19], data_in[18], 
             data_in[17], data_in[15], data_in[14], data_in[13], 
             data_in[12], data_in[11], data_in[10], data_in[9],
             data_in[7],  data_in[6],  data_in[5],  data_in[3]}),
  .err_idx(err_idx),
  .addr_mem_o(addr_mem_o),
  .en_mem(en_mem)
);

endmodule

// SPI Interface Block
// Compatible with modes '00 (CPOL = 0, CPHA = 0) and '11 (CPOL = 1, CPHA = 1)
// in other words, always samples in risign edge
`timescale 1ns/10ps

module spi_if_2 (
  input logic sck,
  input logic sdi,
  input logic cs_n, // active low
  output logic sdo,
  output err_flag,

  // Hamming Interface
  input logic error_flag_i,

  // Memory ROM interface
  input logic [15:0] data_mem_i, // memory_block
  input logic [4:0] err_idx, // hamming_block
  output logic [4:0] addr_mem_o,
  output logic en_mem
);

  logic [4:0] addr_buf, addr_nxt; // address buffer
  logic [15:0] data_reg, data_nxt; // data register
  logic [4:0] err_idx_reg, err_idx_nxt;
  logic err_flag_ff, err_flag_nxt;

  logic sdo_next;

  typedef enum logic [4:0] {
    IDLE,
    RX_A4, RX_A3, RX_A2, RX_A1, RX_A0,
    READ,
    TX_D15, TX_D14, TX_D13, TX_D12, TX_D11, 
    TX_D10, TX_D9, TX_D8, TX_D7, TX_D6, TX_D5, 
    TX_D4, TX_D3, TX_D2, TX_D1, TX_D0, 
    TX_E4, TX_E3, TX_E2, TX_E1, TX_E0
  } state_t;

  state_t next_state;
  state_t curr_state;

  // Next-state logic
  always_ff @(posedge sck) begin : seq_logic
    if (cs_n) begin
      curr_state <= IDLE;
      data_reg <= 16'b0;
      err_idx_reg <= 5'b0;
      sdo <= 1'b0; // Reset serial output data
      err_flag_ff <= 1'b0;
    end else begin
      curr_state <= next_state; // FSM state transition
      addr_buf <= addr_nxt; // Update address buffer
      sdo <= sdo_next; // Update serial output data
      data_reg <= data_nxt; // Update data register
      err_idx_reg <= err_idx_nxt; // Update error index register\
      err_flag_ff <= err_flag_nxt; // Update error flag
    end
  end // end seq_logic always block

  assign addr_mem_o = addr_buf; // Output address to memory
  assign err_flag = err_flag_ff; // Output error flag

  always_comb begin : comb_logic
    // Only CS high end data transmittion
    // Other ways, FSM will send the data and error continuously
    next_state = curr_state;

    addr_nxt = 5'b0;
    data_nxt = data_reg;
    err_idx_nxt = err_idx_reg;
    err_flag_nxt = err_flag_ff;

    sdo_next = 1'b0; // default value
    en_mem = 1'b0; // Disable memory read by default

    // FSM logic
    case (curr_state)
      IDLE: begin
        next_state = RX_A4;
      end

      // Read address (little-endian)
      RX_A4: begin
        addr_nxt = {addr_buf[3:0], sdi}; // Shift in the address bit
        next_state = RX_A3;
      end

      RX_A3: begin
        addr_nxt = {addr_buf[3:0], sdi}; // Shift in the address bit
        next_state = RX_A2;
      end

      RX_A2: begin
        addr_nxt = {addr_buf[3:0], sdi}; // Shift in the address bit
        next_state = RX_A1;
      end

      RX_A1: begin
        addr_nxt = {addr_buf[3:0], sdi}; // Shift in the address bit
        next_state = RX_A0;
      end

      RX_A0: begin
        addr_nxt = {addr_buf[3:0], sdi}; // Shift in the address bit
        next_state = READ; 
        // maybe it can be implemented some intermediate state to get the data from memory
      end

      READ: begin
        addr_nxt = 5'b0; // Reset address buffer in next cycle
        en_mem = 1'b1; // Enable memory read
        next_state = TX_D15;
        data_nxt = data_mem_i; // Capture parallel data from memory block
        err_idx_nxt = err_idx; // Capture error index from hamming block
        err_flag_nxt = error_flag_i; // Capture error flag from hamming block
      end

      // Send data bits (little-endian)
      TX_D15: begin
        sdo_next = data_reg[15];
        next_state = TX_D14;
      end

      TX_D14: begin
        sdo_next = data_reg[14];
        next_state = TX_D13;
      end

      TX_D13: begin
        sdo_next = data_reg[13];
        next_state = TX_D12;
      end

      TX_D12: begin
        sdo_next = data_reg[12];
        next_state = TX_D11;
      end

      TX_D11: begin
        sdo_next = data_reg[11];
        next_state = TX_D10;
      end

      TX_D10: begin
        sdo_next = data_reg[10];
        next_state = TX_D9;
      end

      TX_D9: begin
        sdo_next = data_reg[9];
        next_state = TX_D8;
      end

      TX_D8: begin
        sdo_next = data_reg[8];
        next_state = TX_D7;
      end

      TX_D7: begin
        sdo_next = data_reg[7];
        next_state = TX_D6;
      end

      TX_D6: begin
        sdo_next = data_reg[6];
        next_state = TX_D5;
      end

      TX_D5: begin
        sdo_next = data_reg[5];
        next_state = TX_D4;
      end

      TX_D4: begin
        sdo_next = data_reg[4];
        next_state = TX_D3;
      end

      TX_D3: begin
        sdo_next = data_reg[3];
        next_state = TX_D2;
      end

      TX_D2: begin
        sdo_next = data_reg[2];
        next_state = TX_D1;
      end

      TX_D1: begin
        sdo_next = data_reg[1];
        next_state = TX_D0;
      end

      TX_D0: begin
        sdo_next = data_reg[0];
        next_state = TX_E4;
      end

      // Send error address (little-endian)
      TX_E4: begin
        sdo_next = err_idx_reg[4];
        next_state = TX_E3;
      end

      TX_E3: begin
        sdo_next = err_idx_reg[3];
        next_state = TX_E2;
      end

      TX_E2: begin
        sdo_next = err_idx_reg[2];
        next_state = TX_E1;
      end

      TX_E1: begin
        sdo_next = err_idx_reg[1];
        next_state = TX_E0;
      end

      TX_E0: begin
        sdo_next = err_idx_reg[0];
        next_state = TX_D15;
      end

      default: begin
        sdo_next = 1'b0;
        next_state = IDLE;
      end
    endcase
  end // end comb_logic always block
endmodule

// even-parity, little-endian, extended-hamming code
// hamming distance d = 3 for detection
module h_ext (
  input logic [21:0] data_in,
  output logic [4:0] err_idx,
  output logic error_flag
);

  logic [5:0] parity_chk;
  logic [4:0] syndrome;

  assign parity_chk[1] = ^{data_in[3], data_in[5], data_in[7], data_in[9], 
                           data_in[11], data_in[13], data_in[15], data_in[17], 
                           data_in[19], data_in[21]};       
  assign parity_chk[2] = ^{data_in[3], data_in[7:6], data_in[11:10], data_in[15:14], data_in[19:18]};
  assign parity_chk[3] = ^{data_in[7:5], data_in[15:12], data_in[21:20]};
  assign parity_chk[4] = ^{data_in[15:9]};
  assign parity_chk[5] = ^{data_in[21:17]};

  assign parity_chk[0] = ^data_in[21:1];

  assign syndrome = parity_chk[5:1] ^ {data_in[16], data_in[8], data_in[4], data_in[2], data_in[1]};

  assign error_flag = |(syndrome);
  assign err_idx = (parity_chk[0] == data_in[0] && error_flag) ? 5'b00000 : syndrome;
  
endmodule

