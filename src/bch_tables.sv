// Utilitários 

function automatic logic [3:0] antilog_table (input int idx);
    case (idx)
        0:  antilog_table = 4'b0001;
        1:  antilog_table = 4'b0010;
        2:  antilog_table = 4'b0100;
        3:  antilog_table = 4'b1000;
        4:  antilog_table = 4'b0011;
        5:  antilog_table = 4'b0110;
        6:  antilog_table = 4'b1100;
        7:  antilog_table = 4'b1011;
        8:  antilog_table = 4'b0101;
        9:  antilog_table = 4'b1010;
        10: antilog_table = 4'b0111;
        11: antilog_table = 4'b1110;
        12: antilog_table = 4'b1111;
        13: antilog_table = 4'b1101;
        14: antilog_table = 4'b1001;
        default: antilog_table = 4'b0000;
    endcase
endfunction

function automatic logic [3:0] log_table (input int idx);
    case (idx)
        0:  log_table = 4'b1111; // log(0) indefinido
        1:  log_table = 4'b0000;
        2:  log_table = 4'b0001;
        3:  log_table = 4'b0100;
        4:  log_table = 4'b0010;
        5:  log_table = 4'b1000;
        6:  log_table = 4'b0101;
        7:  log_table = 4'b1010;
        8:  log_table = 4'b0011;
        9:  log_table = 4'b1110;
        10: log_table = 4'b1001;
        11: log_table = 4'b0111;
        12: log_table = 4'b0110;
        13: log_table = 4'b1101;
        14: log_table = 4'b1011;
        15: log_table = 4'b1100;
        default: log_table = 4'b0000;
    endcase
endfunction

function automatic logic [3:0] gf_mult(input logic [3:0] a, input logic [3:0] b);
    int sum;
    begin
        if (a == 0 || b == 0)
            gf_mult = 4'b0000;
        else begin
            sum = log_table(a) + log_table(b);
            if (sum >= 15) sum -= 15;
            gf_mult = antilog_table(sum);
        end
    end
endfunction

function automatic logic [3:0] gf_pow(input int exp);
    int idx;
    begin
        idx = exp % 15;
        if (idx < 0) idx += 15;
        gf_pow = antilog_table(idx);
    end
endfunction

function automatic logic [3:0] gf_div(input logic [3:0] a, input logic [3:0] b);
    int diff;
    begin
        if (a == 0)
            gf_div = 4'd0;
        else if (b == 0)
            gf_div = 4'd0;
        else begin
            diff = log_table(a) - log_table(b);
            if (diff < 0) diff += 15;
            gf_div = antilog_table(diff);
        end
    end
endfunction

function automatic logic [3:0] alpha_pow(input int i);
    int idx;
    begin
        idx = i % 15;
        if (idx < 0) idx += 15;
        alpha_pow = antilog_table(idx);
    end
endfunction

module gf_multiplier (
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic [3:0] p
);
    always_comb begin
        p = gf_mult(a, b);
    end
endmodule

module gf_divider (
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic [3:0] q
);
    always_comb begin
        q = gf_div(a, b);
    end
endmodule

module gf_power (
    input  logic [3:0] a,
    output logic [3:0] y
);
    always_comb begin
        y = gf_pow(a);
    end
endmodule

module xor_4 (
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic [3:0] y
);

assign y = a^b;

endmodule

module ff_4 (
    input logic clk,
    input logic rst,
    input logic [3:0] a,
    output logic [3:0] q
);

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            q <= 0;
        end else begin
            q <= a;
        end
    end

endmodule


