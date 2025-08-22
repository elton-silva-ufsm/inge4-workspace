module rom_v1_wrap (
    input  [4:0]  ADDR,
    output [15:0] BL
);

    rom_v1 rom_inst (
        .BL   (BL),
        .ADDR (ADDR),
        .IN   (1'b1)
    );

endmodule
