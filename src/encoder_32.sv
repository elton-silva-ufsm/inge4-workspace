module encoder;

localparam TESTS = 1024;

logic [31:0] data;
logic [38:0] ham_encoded;
int file, file1; 
logic par1, par2;

initial begin 
    file = $fopen ("../encoder/rom.hex","w");
    file1 = $fopen ("../encoder/expected.hex","w");

    for (int i = 0; i < TESTS; ++i) begin
        // data = $urandom();
        data = $urandom();

        par2 = ^{data[0], data[3:2], data[6:5], data[10:9], data[13:12], data[17:16], data[21:20], data[25:24], data[28:27], data[31]};
        par1 = ^{data[0],data[1],data[3],data[4],
                 data[6],data[8],data[11:10],data[13],
                 data[15],data[17],data[19],data[21],
                 data[23],data[26:25],data[28],data[30]};

        ham_encoded = {data[31:26], ^{data[31:26]}, data[25:11], ^{data[25:11]}, data[10:4], 
            ^{data[25:18], data[10:4]}, data[3:1], ^{data[3:1],data[10:7],data[17:14],data[25:22],data[31:29]}, 
            data[0], par2, par1, 1'b0};
        
        ham_encoded = {ham_encoded[38:1], ^ham_encoded[38:1]};

        $fdisplay(file1, "%8h", data);
        $fdisplay(file, "%10h", ham_encoded);
    end

    $fclose(file);
    $fclose(file1);
end

endmodule