module error_generator;

    integer fd;
    logic [14:0] err;

    initial begin
        fd = $fopen("../src/input/errors.bin", "wb");
        
        // Vetores de peso 1
        for (int i = 0; i < 15; i++) begin
            err = 15'b0;
            err[i] = 1'b1;
            $fwrite(fd, "%b\n", err);
        end

        // Vetores de peso 2
        for (int i = 0; i < 15; i++) begin
            for (int j = i+1; j < 15; j++) begin
                err = 15'b0;
                err[i] = 1'b1;
                err[j] = 1'b1;
                $fwrite(fd, "%b\n", err);
            end
        end

        $fclose(fd);
        $display("Arquivo errors.bin gerado com sucesso.");
        $finish;
    end

endmodule
