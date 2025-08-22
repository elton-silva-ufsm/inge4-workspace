module or16 (
    input logic [15:0] a,
    output logic y
);

assign y = |a;

endmodule