`timescale 1ns / 1ps

module chien_block (
    input wire clk,
    input wire rst,
    input wire [3:0] lambda1,    // lambda1 input
    input wire [3:0] lambda2,    // lambda2 input
    output reg [14:0] error_vector,  // Change to reg type to assign inside always block
    output wire error_found
);

    // GF(2^4) tables for x^4 + x + 1, ? = 2
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

    // GF power: ?^(exp mod 15)
    function [3:0] gf_pow;
        input integer exp;
        begin
            gf_pow = antilog_table[exp % 15];
        end
    endfunction

    integer i;
    reg [3:0] alpha_neg_i, alpha_neg_i_sq;
    reg [3:0] eval1, eval2, sum;

    always @(*) begin
        error_vector = 15'b0;  // Reset error vector at the start of each evaluation

        for (i = 0; i < 15; i = i + 1) begin
            alpha_neg_i = gf_pow(15 - i); // ?^(-i) ? ?^(15 - i) mod 15
            alpha_neg_i_sq = gf_mult(alpha_neg_i, alpha_neg_i); // (?^(-i))²

            eval1 = gf_mult(lambda1, alpha_neg_i);
            eval2 = gf_mult(lambda2, alpha_neg_i_sq);

            // Evaluate ?(?^(-i)) = 1 + ?1*?^(-i) + ?2*(?^(-i))^2
            sum = 4'd1 ^ eval1 ^ eval2;
            error_vector[i] = (sum == 4'd0) ? 1'b1 : 1'b0;
        end
    end

    // Check if error found
    assign error_found = (error_vector != 15'b0);  // Set error_found if any bit is set in error_vector

endmodule

