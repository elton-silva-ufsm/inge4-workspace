`timescale 1ns / 1ps

// `include "../src/bch/chien_block.v"
// `include "../src/bch_tables.sv"
`include "../src/bch_31_encoder.sv"

module bch_31_pipe_tb;

    reg [20:0] msg;
    wire [30:0] codeword;
    logic [30:0] corrupt;
    wire [30:0] corrected_codeword_o;
    wire error_detected;
    reg clk = 0;
    reg rst;

    bch_31_encoder u_encoder (
    .msg(msg),
    .codeword(codeword)
    );

    bch_31_pipe DUV (
        .clk(clk),
        .rst(rst),
        .codeword(codeword ^ corrupt),
        .corrected_codeword_o(corrected_codeword_o),
        .error_detected(error_detected)
    );

    always #15 clk = ~clk;

    initial begin
        rst = 0;
        clk = 0;
        msg = 21'b000000000000000000000;
        corrupt = 31'd0;
        
        @(negedge clk);
        rst = 1;
        @(negedge clk);

        $display("╒═════════════════════╤═══════════════════════════════╤═══════════════════════════════╤═══════════════════════════════╤═╕");
        $display("│msg                  │codeword                       │corrupted                      │corrected                      │e│");
        $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt^codeword, corrected_codeword_o, error_detected);

        // corrupt = 31'd1;
        // @(negedge clk);
        // $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt^codeword, corrected_codeword_o, error_detected);

        // // 1 error
        // for (int i=0; i<31; ++i) begin
        //     corrupt = 31'd1 << i;
        //     @(negedge clk);
        //     $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt^codeword, corrected_codeword_o, error_detected);
        // end
        // // 2 errors
        // for (int i=0; i<31; ++i) begin
        //     for (int j=i+1; j<31; ++j) begin
        //         corrupt = (31'd1 << i) | (31'd1 << j);
        //         @(negedge clk);
        //         $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt^codeword, corrected_codeword_o, error_detected);   
        //     end
        // end

        // // 3 errors
        // for (int i=0; i<31; ++i) begin
        //     for (int j=i+1; j<31; ++j) begin
        //         for (int k=j+1; k<31; ++k) begin
        //             corrupt = (31'd1 << i) | (31'd1 << j) | (31'd1 << k);
        //             @(negedge clk);
        //             $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt^codeword, corrected_codeword_o, error_detected);   
        //         end
        //     end
        // end

        repeat (5) begin
        @(negedge clk);
        $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt^codeword, corrected_codeword_o, error_detected);
        end
                
        $display("╘═════════════════════╧═══════════════════════════════╧═══════════════════════════════╧═══════════════════════════════╧═╛");
        $finish;
    end

endmodule

