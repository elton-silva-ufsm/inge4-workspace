`timescale 1ns / 1ps

module syndrome_block (
    input wire clk,
    input wire rst,
    input wire [14:0] codeword,
    output reg [3:0] S1,
    output reg [3:0] S2,
    output reg [3:0] S3
);

    // GF(2^4) with primitive polynomial x^4 + x + 1
    reg [3:0] antilog_table [0:14];
    reg [3:0] log_table [0:15];
    integer i;

    initial begin
        // Correct unpacked array initialization per index
        antilog_table[0]  = 4'b0001;
        antilog_table[1]  = 4'b0010;
        antilog_table[2]  = 4'b0100;
        antilog_table[3]  = 4'b1000;
        antilog_table[4]  = 4'b0011;
        antilog_table[5]  = 4'b0110;
        antilog_table[6]  = 4'b1100;
        antilog_table[7]  = 4'b1011;
        antilog_table[8]  = 4'b0101;
        antilog_table[9]  = 4'b1010;
        antilog_table[10] = 4'b0111;
        antilog_table[11] = 4'b1110;
        antilog_table[12] = 4'b1111;
        antilog_table[13] = 4'b1101;
        antilog_table[14] = 4'b1001;

        log_table[0]  = 4'b1111; // log(0) undefined, so set to 15
        log_table[1]  = 4'b0000;
        log_table[2]  = 4'b0001;
        log_table[3]  = 4'b0100;
        log_table[4]  = 4'b0010;
        log_table[5]  = 4'b1000;
        log_table[6]  = 4'b0101;
        log_table[7]  = 4'b1010;
        log_table[8]  = 4'b0011;
        log_table[9]  = 4'b1110;
        log_table[10] = 4'b1001;
        log_table[11] = 4'b0111;
        log_table[12] = 4'b0110;
        log_table[13] = 4'b1101;
        log_table[14] = 4'b1011;
        log_table[15] = 4'b1100;
    end

    // GF(2^4) multiplication
    function [3:0] gf_mult;
        input [3:0] a, b;
        reg [4:0] sum;
        begin
            if (a == 0 || b == 0)
                gf_mult = 0;
            else begin
                sum = log_table[a] + log_table[b];
                if (sum >= 15) sum = sum - 15;
                gf_mult = antilog_table[sum];
            end
        end
    endfunction

    // Compute ?^i
    function [3:0] alpha_pow;
        input integer i;
        integer idx;
        begin
            idx = i % 15;
            if (idx < 0) idx = idx + 15;
            alpha_pow = antilog_table[idx];
        end
    endfunction

    always @(*) begin
        S1 = 4'b0000;
        S2 = 4'b0000;
        S3 = 4'b0000;

        for (i = 0; i < 15; i = i + 1) begin
            if (codeword[i]) begin
                S1 = S1 ^ alpha_pow(i);
                S2 = S2 ^ alpha_pow(2 * i);
                S3 = S3 ^ alpha_pow(3 * i);
            end
        end
    end

endmodule
