module bch_encoder;

    parameter [8:0] GEN = 9'b111010001;
    parameter INPUT_FILE   = "../src/input/i_data_7.hex";
    parameter OUTPUT_FILE  = "../src/input/o_data_bch_15_7.hex";
    parameter OUTPUT_FILE2 = "../src/input/o_data_bch_15_7.bin";

    reg [6:0]  msg [0:127];     // até 128 mensagens de 7 bits
    reg [14:0] codeword;
    reg [14:0] temp;
    reg [7:0] remainder;
    integer i, k, fd, fd2, fd3;

    initial begin
        $readmemh(INPUT_FILE, msg);
        fd = $fopen(OUTPUT_FILE, "w");
        if (fd == 0) begin
            $display("Erro ao abrir arquivo de saída.");
            $finish;
        end
        fd2 = $fopen(OUTPUT_FILE2, "w");
        if (fd2 == 0) begin
            $display("Erro ao abrir arquivo de saída.");
            $finish;
        end

        for (k = 0; k < 128; ++k) begin
            temp = {msg[k], 8'b0};
            for (i = 14; i >= 8; i = i - 1) begin
                if (temp[i]) temp[i -: 9] ^= GEN;
            end
            remainder = temp[7:0];
            codeword  = {msg[k], remainder};

            // Escreve no arquivo .h em hexadecimal
            $fwrite(fd, "%04h\n", codeword);
            $fwrite(fd2, "%15b\n", codeword);
        end

        $fclose(fd);
        $fclose(fd2);
        $display("Geração concluída!");
        $finish;
    end
endmodule
