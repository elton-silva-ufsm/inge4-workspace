`include "../src/bch_31_tables.sv"

module gf_multiplier (
    input  logic [4:0] a,
    input  logic [4:0] b,
    output logic [4:0] p
);
    always_comb begin
        p = gf_mult(a, b);
    end
endmodule

module gf_divider (
    input  logic [4:0] a,
    input  logic [4:0] b,
    output logic [4:0] q
);
    always_comb begin
        q = gf_div(a, b);
    end
endmodule

module gf_power (
    input  logic [4:0] a,
    output logic [4:0] y
);
    always_comb begin
        y = gf_pow(a);
    end
endmodule

module xor_5 (
    input  logic [4:0] a,
    input  logic [4:0] b,
    output logic [4:0] y
);

assign y = a^b;

endmodule

module ff_5 (
    input logic clk,
    input logic rst,
    input logic [4:0] a,
    output logic [4:0] q
);
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            q <= 0;
        end else begin
            q <= a;
        end
    end

endmodule

module bch_31_corrector (
    input logic [30:0] corruptedWord,
    input logic [30:0] errorVector,
    output logic [30:0] correctedWord
);
assign correctedWord = corruptedWord ^ errorVector;
endmodule

module ff_31 (
    input logic clk,
    input logic rst,
    input logic [30:0] a,
    output logic [30:0] q
);
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            q <= 0;
        end else begin
            q <= a;
        end
    end
endmodule