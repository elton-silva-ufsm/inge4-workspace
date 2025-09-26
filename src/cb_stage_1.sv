`include "../src/bch_chien_block.sv"

module cb_stage_1 (
    input logic clk,
    input logic rst,
    input  logic [3:0] lambda1,
    input  logic [3:0] lambda2,
    output logic [14:0] error_vector,
    output logic error_found
);
wire [14:0] error_vector_r;
wire error_found_r;

bch_chien_block cb (
    .lambda1(lambda1),
    .lambda2(lambda2),
    .error_vector(error_vector_r),
    .error_found(error_found_r)
);

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        error_vector <= 15'b0;
        error_found  <= 15'b0;
    end else begin
        error_vector <= error_vector_r;
        error_found  <= error_found_r;
    end
end

endmodule