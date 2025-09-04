module tb_encoder_15_7;

    reg        clk;              // Clock signal
    reg        reset;            // Reset signal
    reg  [6:0] msg;              // 7-bit message input
    wire [14:0] codeword;        // 15-bit encoded output

    // Instantiate the encoder_15_7 module
    encoder_15_7 uut (
        .clk(clk),
        .reset(reset),
        .msg(msg),
        .codeword(codeword)
    );

    // Clock generation: 10ns period for clock signal
    always begin
        #5 clk = ~clk;
    end

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;  // Assert reset initially
        msg = 7'b0000000;  // Initial message

        // Apply reset and then deassert it
        #10;
        reset = 0;  // Deassert reset after 10 time units

        // Display the header for output
        $display("Time | Message  | Codeword");
        $display("----------------------------");

        // Test with example: 1010101 (binary) = 7'b1010101 = decimal 85
        msg = 7'b1010101; #10;
        $display("%4t | %b | %b", $time, msg, codeword);

        // Try a few more test cases
        msg = 7'b0000001; #10;
        $display("%4t | %b | %b", $time, msg, codeword);

        msg = 7'b1111111; #10;
        $display("%4t | %b | %b", $time, msg, codeword);

        msg = 7'b0101010; #10;
        $display("%4t | %b | %b", $time, msg, codeword);

        msg = 7'b0000000; #10;
        $display("%4t | %b | %b", $time, msg, codeword);

        $finish;
    end

endmodule
