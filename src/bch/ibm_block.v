`timescale 1ns / 1ps
module ibm_block (
    input wire clk,
    input wire rst,
    input wire [3:0] S1,
    input wire [3:0] S2,
    input wire [3:0] S3,
    output reg [3:0] lambda1,
    output reg [3:0] lambda2
);

    // GF(2^4) antilog/log tables for x^4 + x + 1 (primitive element ? = 2)
    reg [3:0] antilog_table [0:14];
    reg [3:0] log_table [0:15];

    initial begin
        antilog_table[ 0] = 4'd1;  antilog_table[ 1] = 4'd2;
        antilog_table[ 2] = 4'd4;  antilog_table[ 3] = 4'd8;
        antilog_table[ 4] = 4'd3;  antilog_table[ 5] = 4'd6;
        antilog_table[ 6] = 4'd12; antilog_table[ 7] = 4'd11;
        antilog_table[ 8] = 4'd5;  antilog_table[ 9] = 4'd10;
        antilog_table[10] = 4'd7;  antilog_table[11] = 4'd14;
        antilog_table[12] = 4'd15; antilog_table[13] = 4'd13;
        antilog_table[14] = 4'd9;

        log_table[ 0] = 4'd15; log_table[ 1] = 4'd0;
        log_table[ 2] = 4'd1;  log_table[ 3] = 4'd4;
        log_table[ 4] = 4'd2;  log_table[ 5] = 4'd8;
        log_table[ 6] = 4'd5;  log_table[ 7] = 4'd10;
        log_table[ 8] = 4'd3;  log_table[ 9] = 4'd14;
        log_table[10] = 4'd9;  log_table[11] = 4'd7;
        log_table[12] = 4'd6;  log_table[13] = 4'd13;
        log_table[14] = 4'd11; log_table[15] = 4'd12;
    end

    // GF multiplication
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

    // GF division
    function [3:0] gf_div;
        input [3:0] a, b;
        reg signed [4:0] diff;
        begin
            if (a == 0 || b == 0)
                gf_div = 0;
            else begin
                diff = log_table[a] - log_table[b];
                if (diff < 0) diff = diff + 15;
                gf_div = antilog_table[diff];
            end
        end
    endfunction

    // Temporary variables
    reg [3:0] D1, D2;
    reg [3:0] lambda1_next, lambda2_next;

    always @(posedge clk or posedge rst) begin
    if (rst) begin
        lambda1 <= 4'd0;
        lambda2 <= 4'd0;
    end else begin
        // Compute D1 = S2 + lambda1 * S1
        D1 = S2 ^ gf_mult(lambda1, S1);

        // Compute D2 = S3 + lambda1 * S2 + lambda2 * S1
        D2 = S3 ^ gf_mult(lambda1, S2) ^ gf_mult(lambda2, S1);

        // Update lambda1 and lambda2 using corrected BM logic
        if (S1 != 0) begin
            lambda1_next = gf_div(D1, S1);  // ?1 = D1 / S1
            lambda2_next = gf_div(D2 ^ gf_mult(lambda1_next, S2), S1); // ?2 = (D2 + ?1*S2) / S1
        end else begin
            lambda1_next = 4'd0;
            lambda2_next = 4'd0;
        end

        lambda1 <= lambda1_next;
        lambda2 <= lambda2_next;
    end
end


endmodule
