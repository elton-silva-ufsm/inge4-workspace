module dmux1x8 (
    input logic a,
    input logic [2:0] s,
    output logic [7:0] y
);

always_comb begin
    y = 8'b0;
    case (s)
        3'b000: y[0] = a;
        3'b001: y[1] = a;
        3'b010: y[2] = a;
        3'b011: y[3] = a;
        3'b100: y[4] = a;
        3'b101: y[5] = a;
        3'b110: y[6] = a;
        3'b111: y[7] = a;
    endcase 
end

endmodule
