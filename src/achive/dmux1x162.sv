module dmux1x162 (
    input logic [3:0] ADR,
    output logic [15:0] WL
);

always_comb begin
    WL = 8'b0;
    case (ADR)
        4'b0000: WL[0] = 1;
        4'b0001: WL[1] = 1;
        4'b0010: WL[2] = 1;
        4'b0011: WL[3] = 1;
        4'b0100: WL[4] = 1;
        4'b0101: WL[5] = 1;
        4'b0110: WL[6] = 1;
        4'b0111: WL[7] = 1;
        4'b1000: WL[8] = 1;
        4'b1001: WL[9] = 1;
        4'b1010: WL[10] = 1;
        4'b1011: WL[11] = 1;
        4'b1100: WL[12] = 1;
        4'b1101: WL[13] = 1;
        4'b1110: WL[14] = 1;
        4'b1111: WL[15] = 1;
        default: WL = 16'b0;
    endcase 
end

endmodule
