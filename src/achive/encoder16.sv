module encoder;

  localparam TESTS = 32;

  logic [21:0] data [0:31];      // Dados lidos do arquivo (somente os 16 LSB usados)
  logic [15:0] d;                // Parte de dados (16 bits)
  logic [21:0] ham_encoded;
  int enc_file, dat_file, par_file;
  logic p0, p1, p2, p3, p4, p5;

  initial begin 
    enc_file = $fopen ("../src/input/encoded.hex", "w");
    dat_file = $fopen ("../src/input/data.hex", "w");
    par_file = $fopen ("../src/input/parity.hex", "w");

    $readmemh("data.hex", data); // Lê 32 palavras de 22 bits

    for (int i = 0; i < TESTS; ++i) begin
      d = data[i][15:0]; // Considera apenas os 16 bits de dados úteis

        // Calculate parity bits
        p1 = ^{d[1:0], d[4:3], d[6], d[8], d[11:10], d[13], d[15]};
        // P2
        p2 = ^{d[0], d[3:2], d[6:5], d[10:9], d[13:12]};
        // P4
        p3 = ^{d[3:1], d[10:7], d[15:14]};
        // P8
        p4 = ^{d[10:4]};
        // P16
        p5 = ^{d[15:11]};

        p0 = ^{d, p1, p2, p3, p4, p5};
        ham_encoded = {d[15:11], p5, d[10:4], p4, d[3:1], p3, d[0], p2, p1, p0};

      $fwrite(dat_file, "%h\n", d);
      $fwrite(enc_file, "%h\n", ham_encoded);
      $fwrite(par_file, "%b\n", {p5, p4, p3, p2, p1, p0});
    end

    $fclose(enc_file);
    $fclose(dat_file);
    $fclose(par_file);
    $finish;
  end

endmodule