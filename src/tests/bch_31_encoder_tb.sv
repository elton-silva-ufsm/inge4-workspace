module bch_31_encoder_tb;

logic [19:0] msg;
logic [30:0] codeword;

bch_31_encoder encoder (
    .msg       (msg),
    .codeword  (codeword)  
);

initial begin

    // Test vector
    msg = 20'b10101010101010101010; // Example 20-bit message
    #10; // Wait for 10 time units

    // Display the result
    $display("Message: %b", msg);
    $display("Codeword: %b", codeword);

    $finish;

end

endmodule