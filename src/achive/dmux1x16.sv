module dmux1x16 (
    input logic IN,
    input logic ADR4,
    input logic [3:0] ADR,
    output logic [15:0] WL,
    output logic WB
);

assign WB = (ADR4 & IN);

always_comb begin
    WL = 8'b0;
    case (ADR)
        4'b0000: WL[0] = IN;
        4'b0001: WL[1] = IN;
        4'b0010: WL[2] = IN;
        4'b0011: WL[3] = IN;
        4'b0100: WL[4] = IN;
        4'b0101: WL[5] = IN;
        4'b0110: WL[6] = IN;
        4'b0111: WL[7] = IN;
        4'b1000: WL[8] = IN;
        4'b1001: WL[9] = IN;
        4'b1010: WL[10] = IN;
        4'b1011: WL[11] = IN;
        4'b1100: WL[12] = IN;
        4'b1101: WL[13] = IN;
        4'b1110: WL[14] = IN;
        4'b1111: WL[15] = IN;
        default: WL = 16'b0;
    endcase 
end

endmodule
