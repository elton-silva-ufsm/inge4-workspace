// module bch_pipelined_tb;

//     parameter string INPUT_FILE = "../src/input/o_data_bch_15_7.hex";
//     parameter string ERROR_FILE = "../src/input/errors.bin";

//     logic clk;
//     logic rst;
//     logic [14:0] codeword;
//     logic [14:0] corrected_codeword;
//     logic error_flag;

//     logic [14:0] r_x [0:127];
//     logic [14:0] e_x [0:127];

//     int i;
//     int acerto, erro;

//     bch_pipelined DUV (
//         .clk(clk),
//         .rst(rst),
//         .codeword(codeword),
//         .corrected_codeword(corrected_codeword),
//         .error_flag(error_flag)
//     );

//     initial begin
//         clk = 0;
//         forever #15 clk = ~clk;
//     end

//     initial begin
//         $display("Leitura de arquivos...");
//         $readmemh(INPUT_FILE, r_x);
//         $readmemb(ERROR_FILE, e_x);

//         acerto = 0;
//         erro   = 0;
//         i      = 0;

//         rst = 0;
//         codeword = '0;
//         @(negedge clk);
//         rst = 1;

//         for (i = 0; i < 128; i++) begin
//             codeword = r_x[i] ^ e_x[1]; 
//             @(negedge clk);
//         end

//         repeat (4) begin @(negedge clk) ++i; end

//         $display("Resumo final: acertos=%0d, erros=%0d", acerto, erro);
//         $finish;
//     end

//     always @(negedge clk) begin
//         if (i > 3) begin
//             if (corrected_codeword == r_x[i-4]) begin
//                 acerto++;
//                 // $display("PASS | got=%4h | exp=%4h", corrected_codeword, r_x[i-4]);
//             end else begin
//                 erro++;
//                 $display("FAIL | got=%4h | exp=%4h", corrected_codeword, r_x[i-4]);
//             end
//         end
//     end

// endmodule


module bch_pipelined_tb;

    parameter string INPUT_FILE = "../src/input/o_data_bch_15_7.hex";
    parameter string ERROR_FILE = "../src/input/until_5_errors.bin";

    logic clk;
    logic rst;
    logic [14:0] codeword;
    logic [14:0] corrected_codeword;
    logic error_flag;

    logic [14:0] r_x [0:127];
    logic [14:0] e_x [0:4942];

    int i;
    int acerto, erro;


    logic [14:0] c, e;

    bch_pipelined DUV (
        .clk(clk),
        .rst(rst),
        .codeword(codeword),
        .corrected_codeword(corrected_codeword),
        .error_flag(error_flag)
    );

    initial begin
        clk = 0;
        forever #15 clk = ~clk;
    end

    initial begin
        $display("Leitura de arquivos...");
        $readmemh(INPUT_FILE, r_x);
        $readmemb(ERROR_FILE, e_x);

        acerto = 0;
        erro   = 0;
        i      = 0;
        c      = 0;
        e      = 0;

        rst = 0;
        codeword = '0;
        @(negedge clk);
        rst = 1;

        for (i = 0; i < 120; i++) begin
            c = r_x[i];
            e = e_x[i];
            codeword = c ^ e; 
            @(negedge clk);
        end

        repeat (4) begin @(negedge clk) ++i; end

        $display("Resumo final: acertos=%0d, erros=%0d", acerto, erro);
        $finish;
    end

    always @(negedge clk) begin
        if (i > 3) begin
            if (corrected_codeword == r_x[i-4]) begin
                acerto++;
            end else begin
                erro++;
            end
        end
    end

endmodule