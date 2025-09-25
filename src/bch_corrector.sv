module bch_corrector (
    input logic [14:0] corruptedWord,
    input logic [14:0] errorVector,

    output logic [14:0] correctedWord
);

assign correctedWord = corruptedWord ^ errorVector;

endmodule