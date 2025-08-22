module dmux1x16_3_tb;

  logic IN;
  logic ADR4;
  logic [3:0] ADR;
  logic [15:0] WL;
  logic WB;
  
  dmux1x16_3 dut (
    .IN(IN),
    .ADR4(ADR4),
    .ADR(ADR),
    .WL(WL),
    .WB(WB)
  );

  initial begin

    for (int in_val = 0; in_val <= 1; in_val++) begin
      for (int adr4_val = 0; adr4_val <= 1; adr4_val++) begin
        for (int adr_val = 0; adr_val < 16; adr_val++) begin
          IN = in_val;
          ADR4 = adr4_val;
          ADR = adr_val[3:0];
          #50ns; // Delay to allow the output to stabilize
        end
      end
    end
    $finish;
  end

endmodule
