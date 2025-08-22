module dmux1x16_3 (
    input  logic IN,
    input  logic ADR4,
    input  logic [3:0] ADR,
    output logic [15:0] WL,
    output logic WB
);

assign WB = ADR4 & IN;

always_comb begin
    if (IN)
        WL = 16'b1 << ADR;
    else
        WL = 16'b0;
end

endmodule
