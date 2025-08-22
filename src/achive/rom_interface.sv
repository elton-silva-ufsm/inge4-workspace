module rom_interface (
    input logic [4:0] a,
    output logic [15:0] y
);

rom_v1 rom (
    .WL(),
    .BL(),
);

dmux1x16 dmux (
    .a(),
    .s(a[4:1]),
    .y()
);

line_dc line_dc (
    .a(),
    .y()
);


endmodule