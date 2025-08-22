module and16_tb;

    logic [15:0] a;
    logic y;

    // Instância do módulo a ser testado
    and16 dut (
        .a(a),
        .y(y)
    );

    initial begin
        $display("Tempo(ns)\ta\t\t\t y");
        $display("-------------------------------");


        a = 16'hFFFF;
        #5;
        $display("%0t\t%b\t %b", $time, a, y);
        
        for (int i = 0; i < 16; ++i) begin
            a = 16'hFFFF ^ (1 << i);
            #5;
            $display("%0t\t%b\t %b", $time, a, y);
        end

        a = 16'h0000;
        #5;
        $display("%0t\t%b\t %b", $time, a, y);

        for (int i = 0; i < 16; ++i) begin
            a = 16'h0000 ^ (1 << i);
            #5;
            $display("%0t\t%b\t %b", $time, a, y);
        end

        $finish;
    end

endmodule
