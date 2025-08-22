module and16 (
  input logic [15:0] A,
  output logic Y 
);

assign Y = &A; 

endmodule