module error_generator31;
    integer fd;
    logic [30:0] err;

    initial begin
        fd = $fopen("../src/input/31_5_errors.bin", "w");

        // Vetores de peso 1
        for (int i = 0; i < 31; i++) begin
            err = 31'b0;
            err[i] = 1'b1;
            $fwrite(fd, "%031b\n", err);
        end

        // Vetores de peso 2
        for (int i = 0; i < 31; i++) begin
            for (int j = i+1; j < 31; j++) begin
                err = 31'b0;
                err[i] = 1'b1;
                err[j] = 1'b1;
                $fwrite(fd, "%031b\n", err);
            end
        end

        // Vetores de peso 3
        for (int i = 0; i < 31; i++) begin
            for (int j = i+1; j < 31; j++) begin
                for (int k = j+1; k < 31; k++) begin
                    err = 31'b0;
                    err[i] = 1'b1;
                    err[j] = 1'b1;
                    err[k] = 1'b1;
                    $fwrite(fd, "%031b\n", err);
                end
            end
        end

        // Vetores de peso 4
        for (int i = 0; i < 31; i++) begin
            for (int j = i+1; j < 31; j++) begin
                for (int k = j+1; k < 31; k++) begin
                    for (int l = k+1; l < 31; l++) begin
                        err = 31'b0;
                        err[i] = 1'b1;
                        err[j] = 1'b1;
                        err[k] = 1'b1;
                        err[l] = 1'b1;
                        $fwrite(fd, "%031b\n", err);
                    end
                end
            end
        end

        // Vetores de peso 5
        for (int i = 0; i < 31; i++) begin
            for (int j = i+1; j < 31; j++) begin
                for (int k = j+1; k < 31; k++) begin
                    for (int l = k+1; l < 31; l++) begin
                        for (int m = l+1; m < 31; m++) begin
                            err = 31'b0;
                            err[i] = 1'b1;
                            err[j] = 1'b1;
                            err[k] = 1'b1;
                            err[l] = 1'b1;
                            err[m] = 1'b1;
                            $fwrite(fd, "%031b\n", err);
                        end
                    end
                end
            end
        end




    end

endmodule