// module rom_to_csv;

//   logic [15:0] data [0:31];           // 32 palavras
//   logic matrix [0:31][0:15];          // 32 linhas, 16 colunas
//   integer file_out;
//   int row_base;

//   initial begin
//     // Lê os dados do arquivo HEX
//     $readmemh("../src/input/data.hex", data);

//     // Preenche a matriz de acordo com o mapeamento especial
//     for (int col = 0; col < 16; col++) begin
//       for (int bit_n = 15; bit_n >= 0; bit_n--) begin
//         row_base = 2 * (15 - bit_n);
//         matrix[row_base][col]     = data[col][bit_n];     // data[n]
//         matrix[row_base + 1][col] = data[col + 16][bit_n]; // data[n+16]
//       end
//     end

//     // Salva no CSV (linha por linha)
//     file_out = $fopen("../src/input/matrix.csv", "w");
//     if (!file_out) begin
//       $display("Erro ao abrir arquivo CSV.");
//       $finish;
//     end

//     for (int row = 0; row < 32; row++) begin
//       for (int col = 0; col < 16; col++) begin
//         $fwrite(file_out, "%0d", matrix[row][col]);
//         if (col != 15) $fwrite(file_out, ",");
//       end
//       $fwrite(file_out, "\n");
//     end

//     $fclose(file_out);
//     $display("matrix.csv gerado com sucesso.");
//     $finish;
//   end

// endmodule
/// Author : John Doe
// module rom_to_csv;

//   logic [15:0] data [0:31];           // 32 words / 16 bits
//   logic matrix [0:31][0:15];          // 32 lines, 16 columns
//   integer file_out;

//   initial begin
//     // Lê os dados do arquivo HEX
//     $readmemh("../src/input/data.hex", data);

//     for (int j = 0; j < 16; j++) begin
//       for (int i = 0; i < 22/2; i++) begin
//         matrix[i][j] = data[i][j];
//       end
//     end
//     // Salva no CSV (linha por linha)
//     file_out = $fopen("../src/input/matrix.csv", "w");
//     if (!file_out) begin
//       $display("Erro ao abrir arquivo CSV.");
//       $finish;
//     end

//     for (int i = 0; i < 32; i++) begin
//       for (int j = 0; j < 16; j++) begin
//         $fwrite(file_out, "%0d", matrix[row][col]);
//         if (col != 15) $fwrite(file_out, ",");
//       end
//       $fwrite(file_out, "\n");
//     end

//     $fclose(file_out);
//     $display("matrix.csv gerado com sucesso.");
//     $finish;
//   end

// endmodule

// module rom_to_csv;

//   logic [21:0] data [0:31];             // 32 palavras de 22 bits
//   logic matrix [0:31][0:21];            // 32 linhas, 22 colunas
//   integer file_out;
//   int row_base;

//   initial begin
//     // Lê os dados do arquivo HEX
//     $readmemh("../src/input/encoded.hex", data);

//     // Preenche a matriz de acordo com o mapeamento especial
//     for (int col = 0; col < 22; col++) begin
//       for (int bit_n = 21; bit_n >= 0; bit_n--) begin
//         row_base = 2 * (21 - bit_n);
//         matrix[row_base][col]     = data[col][bit_n];      // data[n]
//         matrix[row_base + 1][col] = data[col + 10][bit_n]; // data[n+10]
//       end
//     end

//     // Salva no CSV (linha por linha)
//     file_out = $fopen("../src/input/HMatrix.csv", "w");
//     if (!file_out) begin
//       $display("Erro ao abrir arquivo CSV.");
//       $finish;
//     end

//     for (int row = 0; row < 32; row++) begin
//       for (int col = 0; col < 22; col++) begin
//         $fwrite(file_out, "%0d", matrix[row][col]);
//         if (col != 21) $fwrite(file_out, ",");
//       end
//       $fwrite(file_out, "\n");
//     end

//     $fclose(file_out);
//     $display("HMatrix.csv gerado com sucesso.");
//     $finish;
//   end

// endmodule


// module rom_to_csv;

//   logic [21:0] data [0:31];           // 32 palavras
//   logic matrix [0:43][0:15];          // 44 linhas, 16 colunas
//   integer file_out;
//   int row_base;

//   initial begin
//     // Lê os dados do arquivo HEX
//     $readmemh("../src/input/encoded.hex", data);

//     // Preenche a matriz de acordo com o mapeamento especial
//     for (int col = 0; col < 16; col++) begin
//       for (int bit_n = 15; bit_n >= 0; bit_n--) begin
//         row_base = 2 * (15 - bit_n);
//         matrix[row_base][col]     = data[col][bit_n];     // data[n]
//         matrix[row_base + 1][col] = data[col + 16][bit_n]; // data[n+16]
//       end
//     end

//     // Salva no CSV (linha por linha)
//     file_out = $fopen("../src/input/HMatrix.csv", "w");
//     if (!file_out) begin
//       $display("Erro ao abrir arquivo CSV.");
//       $finish;
//     end

//     for (int row = 0; row < 32; row++) begin
//       for (int col = 0; col < 16; col++) begin
//         $fwrite(file_out, "%0d", matrix[row][col]);
//         if (col != 15) $fwrite(file_out, ",");
//       end
//       $fwrite(file_out, "\n");
//     end

//     $fclose(file_out);
//     $display("matrix.csv gerado com sucesso.");
//     $finish;
//   end

// endmodule