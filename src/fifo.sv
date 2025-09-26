module fifo (
    input  logic        clk,
    input  logic        rst,
    input  logic [14:0] d_in,
    output logic [14:0] d_out
);

reg [14:0] mem [0:3];

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        mem[0] <= 15'b0;
        mem[1] <= 15'b0;
        mem[2] <= 15'b0;
        mem[3] <= 15'b0;
        d_out   <= 15'b0;
    end else begin
        mem[0] <= d_in;
        mem[1] <= mem[0];
        mem[2] <= mem[1];
        mem[3] <= mem[2];
        d_out   <= mem[3];
    end
end

endmodule