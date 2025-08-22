// SPI Interface Block
// Compatible with modes '00 (CPOL = 0, CPHA = 0) and '11 (CPOL = 1, CPHA = 1)
// in other words, always samples in risign edge
`timescale 1ns/10ps

module spi_if_3 (
  input logic sck, // active high, main clock
  input logic sdi,
  input logic cs_n, // active low, assync reset
  output logic sdo,
  output logic err_flag,

  // Memory ROM interface
  input logic [15:0] data_mem_i, // memory_block data
  input logic alarm_sig_i,
  output logic [4:0] addr_mem_o, // address register
  output logic en_mem
);

  logic [4:0] addr_buf, addr_nxt; // address buffer
  logic [15:0] data_reg, data_nxt; // data register
  logic alarm_sig_ff, alarm_sig_nxt;

  assign err_flag = alarm_sig_ff;

  logic sdo_next;

  typedef enum logic [4:0] {
    IDLE, 
    RX_A4, RX_A3, RX_A2, RX_A1, RX_A0,
    READ,
    TX_D15, TX_D14, TX_D13, TX_D12, TX_D11, 
    TX_D10, TX_D9, TX_D8, TX_D7, TX_D6, TX_D5, 
    TX_D4, TX_D3, TX_D2, TX_D1, TX_D0
  } state_t;

  state_t next_state;
  state_t curr_state;

  // Next-state logic
  always_ff @(posedge sck) begin : seq_logic
    if (cs_n) begin
      curr_state <= IDLE;
      data_reg <= 16'b0;
      sdo <= 1'b0; // Reset serial output data
      alarm_sig_ff <= 1'b0;
    end else begin
      curr_state <= next_state; // FSM state transition
      addr_buf <= addr_nxt; // Update address buffer
      sdo <= sdo_next; // Update serial output data
      data_reg <= data_nxt; // Update data register
      alarm_sig_ff <= alarm_sig_nxt; // Update alarm signal
    end
  end // end seq_logic always block

  assign addr_mem_o = addr_buf; // Output address to memory

  always_comb begin : comb_logic
    // Only CS high end data transmittion
    // FSM will send the data continuously until that
    next_state = curr_state;

    addr_nxt = 5'b0;
    data_nxt = data_reg;
    alarm_sig_nxt = alarm_sig_ff;

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
      end

      READ: begin
        addr_nxt = 5'b0; // Reset address buffer in next cycle
        en_mem = 1'b1; // Enable memory read
        next_state = TX_D15;
        data_nxt = data_mem_i; // Capture parallel data from memory block
        alarm_sig_nxt = ~alarm_sig_i; // Capture alarm signal from memory block, inverted logic
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
        next_state = TX_D15;
      end

      default: begin
        sdo_next = 1'b0;
        next_state = IDLE;
      end
    endcase
  end // end comb_logic always block
endmodule