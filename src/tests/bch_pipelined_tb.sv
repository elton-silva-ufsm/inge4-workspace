// module bch_pipelined_tb;

//     logic clk;
//     logic rst;
//     logic [14:0] codeword;

//     logic [14:0] corrected_codeword;
//     logic error_flag;

//     // Instantiate the DUV
//     bch_pipelined DUV (
//         .clk(clk),
//         .rst(rst),
//         .codeword(codeword),
//         .corrected_codeword(corrected_codeword),
//         .error_flag(error_flag)
//     );

//     // Clock generation
//     initial begin
//         clk = 0;
//         forever #15ns clk = ~clk; // 10 time units clock period
//     end

//     // Test sequence
//     initial begin
//         // Initialize inputs
//         rst = 0;
//         codeword = 15'b000000000000000; // No error
//         @(negedge clk);
//         rst = 1;

//         @(negedge clk);
//         codeword = 15'b000000000000011;
//         @(negedge clk);
//         codeword = 15'b000000000001100;
//         @(negedge clk);
//         codeword = 15'b000000000011000;
//         @(negedge clk);
//         codeword = 15'b000000000110000;
//         @(negedge clk);
//         codeword = 15'b000000001100000;
//         @(negedge clk);
//         codeword = 15'b000000011000000;
//         @(negedge clk);
//         codeword = 15'b000000110000000;
//         repeat (10) @(negedge clk);
//         $finish;
//     end

// endmodule



module bch_pipelined_tb;

    parameter string INPUT_FILE   = "../src/input/o_data_bch_15_7.hex";
    parameter string ERROR_FILE   = "../src/input/errors.bin";

    logic clk;
    logic rst;
    logic [14:0] codeword;
    logic [14:0] corrected_codeword;
    logic error_flag;

    logic [14:0] r_x [0:127];
    logic [14:0] e_x [0:127];

    bch_pipelined DUV (
        .clk(clk),
        .rst(rst),
        .codeword(codeword),
        .corrected_codeword(corrected_codeword),
        .error_flag(error_flag)
    );

    initial begin
        clk = 0;
        forever #15 clk = ~clk;
    end

    initial begin
        $display("Leitura de arquivos...");
        $readmemh(INPUT_FILE, r_x);
        $readmemb(ERROR_FILE, e_x);

        // reset
        rst = 0;
        codeword = 15'd0;
        @(negedge clk);
        rst = 1;
        
        for (int i = 0; i < 128; i++) begin
            codeword = r_x[1] ^ e_x[i];
            @(negedge clk);
        end

        repeat (10) @(negedge clk);
        $finish;

    end

endmodule
