module column_decoder_tb;

  logic [15:0] BL;
  logic        ADR;
  logic [31:0] BLE;
  logic [15:0] patterns [3:0];

  // Instancia o módulo sob teste
  column_decoder uut (
    .BL(BL),
    .ADR(ADR),
    .BLE(BLE)
  );

  initial begin
    $display("Início dos testes com bits únicos ativados:");

    // Testa cada bit de BL individualmente ativado
    for (int i = 0; i < 16; i++) begin
      BL = 16'b1 << i;

      ADR = 0;
      #1;
      $display("ADR=0 | BL[%0d]=1 | BLE=0x%b", i, BLE);

      ADR = 1;
      #1;
      $display("ADR=1 | BL[%0d]=1 | BLE=0x%b", i, BLE);
    end

    // Padrões representativos
    patterns [0] = 16'h0000; // Apenas o bit 0
    patterns [1] = 16'hffff; // Apenas o bit 1
    patterns [2] = 16'h5555; // Padrão alternado
    patterns [3] = 16'haaaa; // Padrão alternado inverso

    $display("\nTestes com padrões fixos:");

    for (int p = 0; p < 4; p++) begin
      BL = patterns[p];

      ADR = 0;
      #1;
      $display("ADR=0 | BL=0x%h | BLE=0x%h", BL, BLE);

      ADR = 1;
      #1;
      $display("ADR=1 | BL=0x%h | BLE=0x%h", BL, BLE);
    end

    $display("\nTestes concluídos.");
    $finish;
  end

endmodule
