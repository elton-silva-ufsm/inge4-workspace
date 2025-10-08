// ANTI-LOG: idx → α^idx
function automatic logic [4:0] antilog_table (input int idx);
    case (idx)
        0:  antilog_table = 5'b00001; // 1   = 1                 = 'd1  
        1:  antilog_table = 5'b00010; // α   = x                 = 'd2  
        2:  antilog_table = 5'b00100; // α²  = x²                = 'd4  
        3:  antilog_table = 5'b01000; // α³  = x³                = 'd8  
        4:  antilog_table = 5'b10000; // α⁴  = x⁴                = 'd16 
        5:  antilog_table = 5'b00101; // α⁵  = x²+1              = 'd5  
        6:  antilog_table = 5'b01010; // α⁶  = x³+x              = 'd10 
        7:  antilog_table = 5'b10100; // α⁷  = x⁴+x²             = 'd20 
        8:  antilog_table = 5'b01101; // α⁸  = x³+x²+1           = 'd13 
        9:  antilog_table = 5'b11010; // α⁹  = x⁴+x³+x           = 'd26 
        10: antilog_table = 5'b10001; // α¹⁰ = x⁴+1              = 'd17 
        11: antilog_table = 5'b00111; // α¹¹ = x²+x+1            = 'd7  
        12: antilog_table = 5'b01110; // α¹² = x³+x²+x           = 'd14 
        13: antilog_table = 5'b11100; // α¹³ = x⁴+x³+x²          = 'd28 
        14: antilog_table = 5'b11101; // α¹⁴ = x⁴+x³+x²+1        = 'd29 
        15: antilog_table = 5'b11111; // α¹⁵ = x⁴+x³+x²+x+1      = 'd31 
        16: antilog_table = 5'b11011; // α¹⁶ = x⁴+x³+x+1         = 'd27 
        17: antilog_table = 5'b10011; // α¹⁷ = x⁴+x+1            = 'd19 
        18: antilog_table = 5'b00011; // α¹⁸ = x+1               = 'd3  
        19: antilog_table = 5'b00110; // α¹⁹ = x²+x              = 'd6  
        20: antilog_table = 5'b01100; // α²⁰ = x³+x²             = 'd12 
        21: antilog_table = 5'b11000; // α²¹ = x⁴+x³             = 'd24 
        22: antilog_table = 5'b10101; // α²² = x⁴+x²+1           = 'd21 
        23: antilog_table = 5'b01111; // α²³ = x³+x²+x+1         = 'd15 
        24: antilog_table = 5'b11110; // α²⁴ = x⁴+x³+x²+x        = 'd30 
        25: antilog_table = 5'b11001; // α²⁵ = x⁴+x³+1           = 'd25  
        26: antilog_table = 5'b10111; // α²⁶ = x⁴+x²+x+1         = 'd23 
        27: antilog_table = 5'b01011; // α²⁷ = x³+x+1            = 'd11  
        28: antilog_table = 5'b10110; // α²⁸ = x⁴+x²+x           = 'd22 
        29: antilog_table = 5'b01001; // α²⁹ = x³+1              = 'd9 
        30: antilog_table = 5'b10010; // α³⁰ = x⁴+x              = 'd18
        31: antilog_table = 5'b00000; // α⁻∞ = 0
        default: antilog_table = 5'b00000;
    endcase
endfunction

function automatic int log_table (input logic [4:0] val);
    case (val)
        5'd0 : log_table = 5'd31; // log(0) indefinido
        5'd1 : log_table = 5'd0 ;  
        5'd2 : log_table = 5'd1 ;  
        5'd3 : log_table = 5'd18;  
        5'd4 : log_table = 5'd2 ;  
        5'd5 : log_table = 5'd5 ;  
        5'd6 : log_table = 5'd19;  
        5'd7 : log_table = 5'd11;  
        5'd8 : log_table = 5'd3 ;   
        5'd9 : log_table = 5'd29;  
        5'd10: log_table = 5'd6 ;  
        5'd11: log_table = 5'd27;  
        5'd12: log_table = 5'd20;  
        5'd13: log_table = 5'd8 ;  
        5'd14: log_table = 5'd12;  
        5'd15: log_table = 5'd23;  
        5'd16: log_table = 5'd4 ;   
        5'd17: log_table = 5'd10;   
        5'd18: log_table = 5'd30;  
        5'd19: log_table = 5'd17;  
        5'd20: log_table = 5'd7 ;  
        5'd21: log_table = 5'd22;  
        5'd22: log_table = 5'd28;  
        5'd23: log_table = 5'd26;  
        5'd24: log_table = 5'd21;  
        5'd25: log_table = 5'd25;  
        5'd26: log_table = 5'd9 ;  
        5'd27: log_table = 5'd16;  
        5'd28: log_table = 5'd13;  
        5'd29: log_table = 5'd14;  
        5'd30: log_table = 5'd24;  
        5'd31: log_table = 5'd15;  
        default:  log_table = 5'd0;
    endcase
endfunction


function automatic logic [4:0] gf_mult(input logic [4:0] a, input logic [4:0] b);
    int sum;
    begin
        if (a == 0 || b == 0)
            gf_mult = 4'b0000;
        else begin
            sum = log_table(a) + log_table(b);
            if (sum >= 31) sum -= 31;
            gf_mult = antilog_table(sum);
        end
    end
endfunction

function automatic logic [4:0] gf_pow(input int exp);
    int idx;
    begin
        idx = exp % 'd31;
        gf_pow = antilog_table(idx);
    end
endfunction

function automatic logic [4:0] gf_div(input logic [4:0] a, input logic [4:0] b);
    int diff;
    begin
        if (a == 0)
            gf_div = 4'd0;
        else if (b == 0)
            gf_div = 4'd0;
        else begin
            diff = log_table(a) - log_table(b);
            if (diff < 0) diff += 31;
            gf_div = antilog_table(diff);
        end
    end
endfunction

// function automatic logic [4:0] alpha_pow(input int i);
//     int idx;
//     begin
//         idx = i % 31;
//         if (idx < 0) idx += 31;
//         alpha_pow = antilog_table(idx);
//     end
// endfunction
