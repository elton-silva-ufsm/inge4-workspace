`include "../src/bch_31_encoder.sv"
`include "../src/bch_31_tables.sv"


module bch_31_syndrome_tb;

logic [20:0] msg;
logic [30:0] codeword;
logic [4:0] S1, S2, S3, S4;

bch_31_encoder encoder (
    .msg       (msg),
    .codeword  (codeword)  
);

bch_31_syndrome sb (
    .codeword(codeword),
    .S1(S1),
    .S2(S2),
    .S3(S3),
    .S4(S4)
);

initial begin


    msg = 21'b000000000000000000001; // Example 21-bit message
    #10; 

    // Display the result
    $display("Message:  %b", msg);
    $display("Codeword: %b", codeword);
    $display("S1: %b", S1);
    $display("S2: %b", S2);
    $display("S3: %b", S3);
    $display("S4: %b", S4);

    $finish;

end


endmodule