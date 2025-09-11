module error_generator5;
    integer fd;
    logic [14:0] err;

    initial begin
        fd = $fopen("../src/input/until_5_errors.bin", "w");

        // Vetores de peso 1
        for (int i = 0; i < 15; i++) begin
            err = 15'b0;
            err[i] = 1'b1;
            $fwrite(fd, "%015b\n", err);
        end

        // Vetores de peso 2
        for (int i = 0; i < 15; i++) begin
            for (int j = i+1; j < 15; j++) begin
                err = 15'b0;
                err[i] = 1'b1;
                err[j] = 1'b1;
                $fwrite(fd, "%015b\n", err);
            end
        end

        // Vetores de peso 3
        for (int i = 0; i < 15; i++) begin
            for (int j = i+1; j < 15; j++) begin
                for (int k = j+1; k < 15; k++) begin
                    err = 15'b0;
                    err[i] = 1'b1;
                    err[j] = 1'b1;
                    err[k] = 1'b1;
                    $fwrite(fd, "%015b\n", err);
                end
            end
        end

        // Vetores de peso 4
        for (int i = 0; i < 15; i++) begin
            for (int j = i+1; j < 15; j++) begin
                for (int k = j+1; k < 15; k++) begin
                    for (int l = k+1; l < 15; l++) begin
                        err = 15'b0;
                        err[i] = 1'b1;
                        err[j] = 1'b1;
                        err[k] = 1'b1;
                        err[l] = 1'b1;
                        $fwrite(fd, "%015b\n", err);
                    end
                end
            end
        end

        // Vetores de peso 5
        for (int i = 0; i < 15; i++) begin
            for (int j = i+1; j < 15; j++) begin
                for (int k = j+1; k < 15; k++) begin
                    for (int l = k+1; l < 15; l++) begin
                        for (int m = l+1; m < 15; m++) begin
                            err = 15'b0;
                            err[i] = 1'b1;
                            err[j] = 1'b1;
                            err[k] = 1'b1;
                            err[l] = 1'b1;
                            err[m] = 1'b1;
                            $fwrite(fd, "%015b\n", err);
                        end
                    end
                end
            end
        end

        $fclose(fd);
        $display("Arquivo until_5_errors.bin gerado com sucesso com 4943 vetores.");
        $finish;
    end
endmodule
