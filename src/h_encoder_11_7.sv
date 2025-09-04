module h_encoder_11_7;

    parameter INPUT_FILE  = "../src/input/i_data_7.hex";
    parameter OUTPUT_FILE = "../src/input/o_data_h_11_7.hex";
    parameter OUTPUT_FILE_BIN = "../src/input/o_data_h_11_7.bin";
    parameter TESTS = 128;

    reg [6:0] data [0:TESTS-1];   // 7 bits de dados
    reg [11:0] encoded;           // 12 bits do código Hamming extendido
    reg p0, p1, p2, p4, p8;       // bits de paridade
    integer i, fd_hex, fd_bin;

    //  bit 11 : d6
    //  bit 10 : d5
    //  bit 9  : d4
    //  bit 8  : p8
    //  bit 7  : d3
    //  bit 6  : d2
    //  bit 5  : d1
    //  bit 4  : p4
    //  bit 3  : d0
    //  bit 2  : p2
    //  bit 1  : p1
    //  bit 0  : p0 (paridade global)

    initial begin
        $readmemh(INPUT_FILE, data);

        fd_hex = $fopen(OUTPUT_FILE, "w");
        if (fd_hex == 0) begin
            $display("Erro ao abrir arquivo de saída HEX.");
            $finish;
        end

        fd_bin = $fopen(OUTPUT_FILE_BIN, "w");
        if (fd_bin == 0) begin
            $display("Erro ao abrir arquivo de saída BIN.");
            $finish;
        end

        for (i = 0; i < TESTS; i = i + 1) begin
            p1 = ^{data[i][0], data[i][1], data[i][3], data[i][4], data[i][6]};
            p2 = ^{data[i][0], data[i][2], data[i][3], data[i][5], data[i][6]};
            p4 = ^{data[i][1], data[i][2], data[i][3]};
            p8 = ^{data[i][4], data[i][5], data[i][6]};
            p0 = ^{data[i], p1, p2, p4, p8};

            encoded = {data[i][6], data[i][5], data[i][4], p8, data[i][3], data[i][2], data[i][1], p4, data[i][0], p2, p1, p0};

            $fwrite(fd_hex, "%03h\n", encoded);
            $fwrite(fd_bin, "%12b\n", encoded);
        end

        $fclose(fd_hex);
        $fclose(fd_bin);
        $display("Codificação Hamming estendido (12,7) concluída!");
        $finish;
    end

endmodule
