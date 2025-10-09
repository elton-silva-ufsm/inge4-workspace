// `timescale 1ns / 1ps

// // `include "../src/bch/chien_block.v"
// // `include "../src/bch_tables.sv"
// `include "../src/bch_31_encoder.sv"

// module bch_31_pipe_tb;

//     reg [20:0] msg;
//     wire [30:0] codeword;
//     logic [30:0] corrupt;
//     wire [30:0] corrected_codeword_o;
//     wire error_detected;
//     reg clk = 0;
//     reg rst;

//     bch_31_encoder u_encoder (
//     .msg(msg),
//     .codeword(codeword)
//     );

//     bch_31_pipe DUV (
//         .clk(clk),
//         .rst(rst),
//         .codeword(codeword ^ corrupt),
//         .corrected_codeword_o(corrected_codeword_o),
//         .error_detected(error_detected)
//     );

//     always #15 clk = ~clk;

//     initial begin
//         rst = 0;
//         clk = 0;
//         msg = 21'b000000000000000000000;
//         corrupt = 31'd0;
        
//         @(negedge clk);
//         rst = 1;
//         @(negedge clk);

//         $display("╒═════════════════════╤═══════════════════════════════╤═══════════════════════════════╤═══════════════════════════════╤═╕");
//         $display("│msg                  │codeword                       │corrupted                      │corrected                      │e│");
//         $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt^codeword, corrected_codeword_o, error_detected);

//         // corrupt = 31'd1;
//         // @(negedge clk);
//         // $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt^codeword, corrected_codeword_o, error_detected);

//         // 1 error
//         for (int i=0; i<31; ++i) begin
//             corrupt = 31'd1 << i;
//             @(negedge clk);
//             $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt^codeword, corrected_codeword_o, error_detected);
//         end
//         // 2 errors
//         for (int i=0; i<31; ++i) begin
//             for (int j=i+1; j<31; ++j) begin
//                 corrupt = (31'd1 << i) | (31'd1 << j);
//                 @(negedge clk);
//                 $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt^codeword, corrected_codeword_o, error_detected);   
//             end
//         end

//         // 3 errors
//         for (int i=0; i<31; ++i) begin
//             for (int j=i+1; j<31; ++j) begin
//                 for (int k=j+1; k<31; ++k) begin
//                     corrupt = (31'd1 << i) | (31'd1 << j) | (31'd1 << k);
//                     @(negedge clk);
//                     $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt^codeword, corrected_codeword_o, error_detected);   
//                 end
//             end
//         end

//         repeat (5) begin
//         @(negedge clk);
//         $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt^codeword, corrected_codeword_o, error_detected);
//         end
                
//         $display("╘═════════════════════╧═══════════════════════════════╧═══════════════════════════════╧═══════════════════════════════╧═╛");
//         $finish;
//     end

// endmodule

`timescale 1ns / 1ps

// `include "../src/bch/chien_block.v"
// `include "../src/bch_tables.sv"
`include "../src/bch_31_encoder.sv"

module bch_31_pipe_tb;

    reg [20:0] msg;
    wire [30:0] codeword;
    logic [30:0] corrupt;
    wire [30:0] corrected_codeword_o;
    wire error_detected;
    reg clk = 0;
    reg rst;

    localparam int numero_de_erros = 1; // Mude esse valor para testar diferentes números de erros (1 a 5)


    logic [30:0] e_x [0:206366]; // 31 bits, até 5 erros (206.367 combinações)

    int inicio, fim, clk_count;

    // Número total de combinações de erros para 1 a 5 erros:
    // Peso 1: 31
    // Peso 2: 465
    // Peso 3: 4495
    // Peso 4: 31465
    // Peso 5: 169911
    initial begin
        case (numero_de_erros)
            1: begin inicio = 0; fim = 30; end
            2: begin inicio = 31; fim = 495; end
            3: begin inicio = 496; fim = 4990; end
            4: begin inicio = 4991; fim = 36455; end
            5: begin inicio = 36456; fim = 206366; end
            default: begin inicio = 0; fim = 31; end
        endcase
    end


    bch_31_encoder u_encoder (
    .msg(msg),
    .codeword(codeword)
    );

    bch_31_pipe DUV (
        .clk(clk),
        .rst(rst),
        .codeword(codeword ^ corrupt),
        .corrected_codeword_o(corrected_codeword_o),
        .error_detected(error_detected)
    );

    always #15 clk = ~clk;

    always @(posedge clk) begin
        clk_count <= clk_count + 1;
            if (numero_de_erros < 3) begin
            $display("│%5d│%31b│%31b│%1b│", clk_count, corrupt^codeword, corrected_codeword_o, error_detected);
            end
    end

    int clk_wef; // cicle with error flag

    initial begin
        $display("╒═════╤═══════════════════════════════╤═══════════════════════════════╤═╕");
        $display("│clk_i│corrupt_v                      │corrected                      │e│");
        $readmemb("../src/input/31_5_errors.bin", e_x);
        rst = 0;
        clk = 0;
        msg = 21'b000000000000000000000;
        corrupt = 31'd0;
        
        @(negedge clk);
        rst = 1;
        @(negedge clk);


        for (int i=inicio; i<=fim; ++i) begin
            // msg = $urandom(); // Comment this line to use the same message for all tests (easier to debug)
            corrupt = e_x[i];
            @(negedge clk);
            if (error_detected) clk_wef++;
        end

        corrupt = 31'd0;
        
        repeat (2) begin
        @(negedge clk);        
        if (error_detected) clk_wef++;
        if (numero_de_erros < 3) begin
            $display("│%5d│%31b│%31b│%1b│", clk_count, corrupt^codeword, corrected_codeword_o, error_detected);
            end else $display("│Supressed output for %0d errors                                        │", numero_de_erros);      
        end        
                     $display("╘═════╧═══════════════════════════════╧═══════════════════════════════╧═╛");

        $display("Total de testes: %0d", (clk_count - 4));
        $display("Ciclos com flag de erro: %0d", clk_wef);
        $display("Taxa de detecção de erros: %0.2f%%", (clk_wef * 100.0) / (clk_count - 4));
        $finish;
    end

endmodule