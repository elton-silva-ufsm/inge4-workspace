`include "../src/bch_tables.sv"

module bch_bm_block (
    input  wire       clk,
    input  wire       rst,
    input  wire [3:0] S1,
    input  wire [3:0] S2,
    input  wire [3:0] S3,
    output reg  [3:0] lambda1,
    output reg  [3:0] lambda2
);

    reg [3:0] D1, D2;
    reg [3:0] lambda1_next, lambda2_next;

    wire [3:0] mult1, mult2, mult3, mult4;
    wire [3:0] div1,  div2;

    wire [3:0] xor1, xor2, xor3, xor4;

    gf_multiplier u_mult1 (.a(lambda1),      .b(S1), .p(mult1));
    gf_multiplier u_mult2 (.a(lambda1),      .b(S2), .p(mult2));
    gf_multiplier u_mult3 (.a(lambda2),      .b(S1), .p(mult3));
    gf_multiplier u_mult4 (.a(lambda1_next), .b(S2), .p(mult4));

    gf_divider    u_div1  (.a(D1),   .b(S1), .q(div1));
    gf_divider    u_div2  (.a(xor1), .b(S1), .q(div2));

    xor_4 u_xor1 (.a(D2),   .b(mult4), .y(xor1));
    xor_4 u_xor2 (.a(S2),   .b(mult1), .y(xor2));
    xor_4 u_xor3 (.a(S3),   .b(mult2), .y(xor3));
    xor_4 u_xor4 (.a(xor3), .b(mult3), .y(xor4));

    ff_4 u_lamb1 (.clk(clk), .rst(rst), .a(lambda1_next), .q(lambda1));
    ff_4 u_lamb2 (.clk(clk), .rst(rst), .a(lambda2_next), .q(lambda2));

    always_comb begin      

        D1 = xor2;
        D2 = xor4;
        // if (S1 != 0) begin
            lambda1_next = div1; 
            lambda2_next = div2; 
        // end else begin
            // lambda1_next = 4'd0;
            // lambda2_next = 4'd0;
        // end
    end

endmodule