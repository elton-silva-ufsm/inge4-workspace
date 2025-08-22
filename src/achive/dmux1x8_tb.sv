// module dmux1x8_tb;

//     // Entradas
//     logic a;
//     logic [2:0] s;

//     // Saídas
//     logic [7:0] y;

//     // Instância do módulo sob teste
//     dmux1x8 uut (
//         .a(a),
//         .s(s),
//         .y(y)
//     );

//     initial begin
//         $display(" a |  s  |        y");
//         for (int i = 0; i <= 1; i++) begin
//             for (int j = 0; j < 8; j++) begin
//                 a = i;
//                 s = j;
//                 #1; 
//                 $display(" %0b | %03b | %b", a, s, y);
//             end
//         end

//         $display("Testes finalizados.");
//         $finish;
//     end

// endmodule

module dmux1x16_tb;

    logic a;
    logic [3:0] s;

    logic [15:0] y;

    dmux1x16 uut (
        .a(a),
        .s(s),
        .y(y)
    );

    initial begin
        $display(" a |   s   |                y");
        for (int i = 0; i <= 1; i++) begin
            for (int j = 0; j < 16; j++) begin
                a = i;
                s = j[3:0];
                #1; 
                $display(" %0b | %04b | %b", a, s, y);
            end
        end

        $display("Testes finalizados.");
        $finish;
    end
endmodule