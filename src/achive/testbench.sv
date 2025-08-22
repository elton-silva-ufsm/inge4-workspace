module testbench;

logic [21:0] ham_v [511:0];
logic [15:0] data_v [511:0];
logic [15:0] parity_v [511:0];
integer errors_1, errors_2, hits_1, hits_2;
integer match_error;

logic [15:0] d_in1, d_out1, d_out2;
logic [4:0] p_in1;
logic error_flag1, error_flag2;
logic [20:0] d_in2;

hamming16 decoder1 (
  .d_in(d_in1),
  .p_in(p_in1),
  .d_out(d_out1),
  .error_flag(error_flag1)
);

hamming16_2 decoder2 (
  .d_in(d_in2),
  .d_out(d_out2), 
  .error_flag(error_flag2)
);

initial begin

  // Initialize the First Test With no errors and no corrections needed
  $display("Starting First Test...");
  $readmemh("../src/tests/vectors/encoded.hex", ham_v); 
  $readmemh("../src/tests/vectors/data.hex", data_v); 
  $readmemh("../src/tests/vectors/parity.hex", parity_v); 

  errors_1 = 0;
  hits_1 = 0;
  errors_2 = 0;
  hits_2 = 0;

  d_in1 = 16'bx;
  p_in1 = 5'bx;
  d_in2 = 21'bx;

  #5ns;

  for (int i = 0; i < 512; i++) begin
    d_in1 = data_v[i];
    d_in2 = ham_v[i];
    p_in1 = parity_v[i];

    #10ns;

    if (d_out1 === data_v[i]) hits_1++;
    else begin
      errors_1++;
      $display("[ENC1] Error at iteration %0d: Expected %0h, got %0h", i, data_v[i], d_out1);
    end

    if (d_out2 === data_v[i]) hits_2++;
    else begin
      errors_2++;
      $display("[ENC2] Error at iteration %0d: Expected %0h, got %0h", i, data_v[i], d_out2);
	    $display("[ENC2] input: %0h, output: %0h, parity_c %0b, parity_i %0b ", d_in2, d_out2, decoder2.parity, decoder2.parity_in);
    end

    if ((errors_1 + errors_2) > 63) begin
      $display("Too many errors");
      $finish;
    end

    end

    $display("First Test completed.");
    $display("[ENC1] Hits: %0d, Errors: %0d", hits_1, errors_1);
    $display("[ENC2] Hits: %0d, Errors: %0d", hits_2, errors_2);

      // Initialize the Second Test With errors and corrections needed
  #10ns;
  $display("Starting Second Test...");

    errors_1 = 0;
    hits_1 = 0;
    errors_2 = 0;
    hits_2 = 0;

  for (int i = 0; i < 512; ++i) begin
    logic [15:0] corrupted_data;
    logic [20:0] corrupted_ham;

    for (int j = 0; j < 16; ++j) begin
      corrupted_data = data_v[i];
      corrupted_data[j] = ~corrupted_data[j];

      corrupted_ham = ham_v[i];
      corrupted_ham[j] = ~corrupted_ham[j]; 


      d_in1 = corrupted_data;
      p_in1 = parity_v[i];
      d_in2 = corrupted_ham;

      #10ns;

      if (d_out1 === data_v[i]) hits_1++;
      else begin
        errors_1++;
        $display("[ENC1] Error at i=%0d j=%0d: Expected %0h, got %0h", i, j, data_v[i], d_out1);
      end

      if (d_out2 === data_v[i]) hits_2++;
      else begin
        errors_2++;
        $display("[ENC2] Error at i=%0d j=%0d: Expected %0h, got %0h", i, j, data_v[i], d_out2);
        $display("[ENC2] input: %0h, output: %0h, parity_c %0b, parity_i %0b, error address: ", d_in2, d_out2, decoder2.parity, decoder2.parity_in, (decoder2.parity^decoder2.parity_in));
      end

      if ((errors_1 + errors_2) > 32) begin
        $display("Too many errors");
        $display("[ENC1] Hits: %0d, Errors: %0d", hits_1, errors_1);
        $display("[ENC2] Hits: %0d, Errors: %0d", hits_2, errors_2); 
        $finish;
      end

    end
  end

  $display("Second Test completed.");
  $display("[ENC1] Hits: %0d, Errors: %0d", hits_1, errors_1);
  $display("[ENC2] Hits: %0d, Errors: %0d", hits_2, errors_2);  

  $finish;

  end

endmodule
