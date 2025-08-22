module rom_v1_tb;

    wire [15:0] BL;
    logic [4:0] ADDR;

    rom_v1 rom_inst (
        .BL(BL),
        .ADDR(ADDR),
        .IN(1'b1),
        .vdd(1'b1),
        .gnd(1'b0)
    );

    initial begin
        ADDR = 5'b00000;
        repeat (32) begin
            #10ns;
            $display("Address: %0d, Data: %0h", ADDR, BL);
            ADDR = ADDR + 1;
        end
        $finish; 
    end

endmodule



module rom_v1 (
    inout wire [15:0] BL,
    input  logic [4:0] ADDR,
    input  logic       IN,
    input  logic       vdd,
    input  logic       gnd
);
endmodule
