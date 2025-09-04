module memory (
    input logic [6:0] adr,
    output logic [14:0] data
);

logic [14:0] mem_array [0:127]; 

initial begin
    $readmemh("../src/input/o_data_7.hex", mem_array);
end

always @(adr) begin
    #10ns
    data = mem_array[adr];
end

endmodule