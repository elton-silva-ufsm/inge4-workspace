module column_decoder (
    input logic [15:0] BL,
    input logic ADR,
    output logic [31:0] BLE
);

always_comb begin
    BLE[0]  = BL[0]  & ~ADR;
    BLE[1]  = BL[1]  & ~ADR;
    BLE[2]  = BL[2]  & ~ADR;
    BLE[3]  = BL[3]  & ~ADR;
    BLE[4]  = BL[4]  & ~ADR;
    BLE[5]  = BL[5]  & ~ADR;
    BLE[6]  = BL[6]  & ~ADR;
    BLE[7]  = BL[7]  & ~ADR;
    BLE[8]  = BL[8]  & ~ADR;
    BLE[9]  = BL[9]  & ~ADR;
    BLE[10] = BL[10] & ~ADR;
    BLE[11] = BL[11] & ~ADR;
    BLE[12] = BL[12] & ~ADR;
    BLE[13] = BL[13] & ~ADR;
    BLE[14] = BL[14] & ~ADR;
    BLE[15] = BL[15] & ~ADR;
    BLE[16] = BL[0] & ADR;
    BLE[17] = BL[1] & ADR;
    BLE[18] = BL[2] & ADR;
    BLE[19] = BL[3] & ADR;
    BLE[20] = BL[4] & ADR;
    BLE[21] = BL[5] & ADR;
    BLE[22] = BL[6] & ADR;
    BLE[23] = BL[7] & ADR;
    BLE[24] = BL[8] & ADR;
    BLE[25] = BL[9] & ADR;
    BLE[26] = BL[10] & ADR;
    BLE[27] = BL[11] & ADR;
    BLE[28] = BL[12] & ADR;
    BLE[29] = BL[13] & ADR;
    BLE[30] = BL[14] & ADR;
    BLE[31] = BL[15] & ADR;
end

endmodule