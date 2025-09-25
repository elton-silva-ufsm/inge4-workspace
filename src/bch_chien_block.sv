// `include "../src/bch_tables.sv"

module bch_chien_block (
    input wire [3:0] lambda1,    // lambda1 input
    input wire [3:0] lambda2,    // lambda2 input
    output reg [14:0] error_vector,  // Change to reg type to assign inside always block
    output wire error_found
);


    logic [3:0] alpha_neg_i, alpha_neg_i_sq;
    logic [3:0] eval1, eval2, sum;


    always_comb begin
        error_vector = 15'b0;

        for (int i = 0; i < 15; i++) begin

            alpha_neg_i    = gf_pow(15 - i);// ?^(-i) ? ?^(15 - i) mod 15
            alpha_neg_i_sq = gf_mult(alpha_neg_i, alpha_neg_i);// (?^(-i))²

            eval1 = gf_mult(lambda1, alpha_neg_i);
            eval2 = gf_mult(lambda2, alpha_neg_i_sq);
            // Evaluate ?(?^(-i)) = 1 + ?1*?^(-i) + ?2*(?^(-i))^2
            sum = 4'd1 ^ eval1 ^ eval2;

            error_vector[i] = (sum == 4'd0) ? (1'b1) : (1'b0);
        end
    end

    // Check if error found
    assign error_found = (error_vector != 15'b0);  // Set error_found if any bit is set in error_vector

endmodule




// `include "../src/bch_tables.sv"

// module bch_chien_block (
//     input logic [3:0] lambda1,    // lambda1 input
//     input logic [3:0] lambda2,    // lambda2 input
//     output logic [14:0] error_vector,  // Change to reg type to assign inside always block
//     output logic error_found
// );

//     logic [3:0] mult1, mult2, mult3;

//     logic [3:0] alpha_neg_i, alpha_neg_i_sq;
//     logic [3:0] eval1, eval2, sum;

//     logic [3:0] a_neg0, a_neg1, a_neg2, 
//                 a_neg3, a_neg4, a_neg5, 
//                 a_neg6, a_neg7, a_neg8, 
//                 a_neg9, a_nega, a_negb, 
//                 a_negc, a_negd, a_nege;

//     logic [3:0] mult1_0, mult1_1, mult1_2, 
//                 mult1_3, mult1_4, mult1_5,
//                 mult1_6, mult1_7, mult1_8,
//                 mult1_9, mult1_a, mult1_b,
//                 mult1_c, mult1_d, mult1_e;

//     logic [3:0] mult2_0, mult2_1, mult2_2, 
//                 mult2_3, mult2_4, mult2_5,
//                 mult2_6, mult2_7, mult2_8,
//                 mult2_9, mult2_a, mult2_b,
//                 mult2_c, mult2_d, mult2_e;

//     logic [3:0] mult3_0, mult3_1, mult3_2, 
//                 mult3_3, mult3_4, mult3_5,
//                 mult3_6, mult3_7, mult3_8,
//                 mult3_9, mult3_a, mult3_b,
//                 mult3_c, mult3_d, mult3_e;


//     logic [3:0] sum_0, sum_1, sum_2, 
//                 sum_3, sum_4, sum_5, 
//                 sum_6, sum_7, sum_8, 
//                 sum_9, sum_a, sum_b, 
//                 sum_c, sum_d, sum_e;


//     gf_multiplier u_mult2_0 (.a(a_neg0), .b(lambda1),   .p(mult2_0)); 
//     gf_multiplier u_mult2_1 (.a(a_neg1), .b(lambda1),   .p(mult2_1)); 
//     gf_multiplier u_mult2_2 (.a(a_neg2), .b(lambda1),   .p(mult2_2)); 
//     gf_multiplier u_mult2_3 (.a(a_neg3), .b(lambda1),   .p(mult2_3)); 
//     gf_multiplier u_mult2_4 (.a(a_neg4), .b(lambda1),   .p(mult2_4)); 
//     gf_multiplier u_mult2_5 (.a(a_neg5), .b(lambda1),   .p(mult2_5)); 
//     gf_multiplier u_mult2_6 (.a(a_neg6), .b(lambda1),   .p(mult2_6)); 
//     gf_multiplier u_mult2_7 (.a(a_neg7), .b(lambda1),   .p(mult2_7)); 
//     gf_multiplier u_mult2_8 (.a(a_neg8), .b(lambda1),   .p(mult2_8)); 
//     gf_multiplier u_mult2_9 (.a(a_neg9), .b(lambda1),   .p(mult2_9)); 
//     gf_multiplier u_mult2_a (.a(a_nega), .b(lambda1),   .p(mult2_a)); 
//     gf_multiplier u_mult2_b (.a(a_negb), .b(lambda1),   .p(mult2_b)); 
//     gf_multiplier u_mult2_c (.a(a_negc), .b(lambda1),   .p(mult2_c)); 
//     gf_multiplier u_mult2_d (.a(a_negd), .b(lambda1),   .p(mult2_d)); 
//     gf_multiplier u_mult2_e (.a(a_nege), .b(lambda1),   .p(mult2_e)); 

//     gf_multiplier u_mult3_0 (.a(mult1_0), .b(lambda2),   .p(mult3_0)); 
//     gf_multiplier u_mult3_1 (.a(mult1_1), .b(lambda2),   .p(mult3_1)); 
//     gf_multiplier u_mult3_2 (.a(mult1_2), .b(lambda2),   .p(mult3_2)); 
//     gf_multiplier u_mult3_3 (.a(mult1_3), .b(lambda2),   .p(mult3_3)); 
//     gf_multiplier u_mult3_4 (.a(mult1_4), .b(lambda2),   .p(mult3_4)); 
//     gf_multiplier u_mult3_5 (.a(mult1_5), .b(lambda2),   .p(mult3_5)); 
//     gf_multiplier u_mult3_6 (.a(mult1_6), .b(lambda2),   .p(mult3_6)); 
//     gf_multiplier u_mult3_7 (.a(mult1_7), .b(lambda2),   .p(mult3_7)); 
//     gf_multiplier u_mult3_8 (.a(mult1_8), .b(lambda2),   .p(mult3_8)); 
//     gf_multiplier u_mult3_9 (.a(mult1_9), .b(lambda2),   .p(mult3_9)); 
//     gf_multiplier u_mult3_a (.a(mult1_a), .b(lambda2),   .p(mult3_a)); 
//     gf_multiplier u_mult3_b (.a(mult1_b), .b(lambda2),   .p(mult3_b)); 
//     gf_multiplier u_mult3_c (.a(mult1_c), .b(lambda2),   .p(mult3_c)); 
//     gf_multiplier u_mult3_d (.a(mult1_d), .b(lambda2),   .p(mult3_d)); 
//     gf_multiplier u_mult3_e (.a(mult1_e), .b(lambda2),   .p(mult3_e)); 


//     gf_multiplier u_mult1_0 (.a(a_neg0), .b(a_neg0),    .p(mult1_0)); 
//     gf_multiplier u_mult1_1 (.a(a_neg1), .b(a_neg1),    .p(mult1_1)); 
//     gf_multiplier u_mult1_2 (.a(a_neg2), .b(a_neg2),    .p(mult1_2)); 
//     gf_multiplier u_mult1_3 (.a(a_neg3), .b(a_neg3),    .p(mult1_3)); 
//     gf_multiplier u_mult1_4 (.a(a_neg4), .b(a_neg4),    .p(mult1_4)); 
//     gf_multiplier u_mult1_5 (.a(a_neg5), .b(a_neg5),    .p(mult1_5)); 
//     gf_multiplier u_mult1_6 (.a(a_neg6), .b(a_neg6),    .p(mult1_6)); 
//     gf_multiplier u_mult1_7 (.a(a_neg7), .b(a_neg7),    .p(mult1_7)); 
//     gf_multiplier u_mult1_8 (.a(a_neg8), .b(a_neg8),    .p(mult1_8)); 
//     gf_multiplier u_mult1_9 (.a(a_neg9), .b(a_neg9),    .p(mult1_9)); 
//     gf_multiplier u_mult1_a (.a(a_nega), .b(a_nega),    .p(mult1_a)); 
//     gf_multiplier u_mult1_b (.a(a_negb), .b(a_negb),    .p(mult1_b)); 
//     gf_multiplier u_mult1_c (.a(a_negc), .b(a_negc),    .p(mult1_c)); 
//     gf_multiplier u_mult1_d (.a(a_negd), .b(a_negd),    .p(mult1_d)); 
//     gf_multiplier u_mult1_e (.a(a_nege), .b(a_nege),    .p(mult1_e)); 

//     gf_power      u_alpha_neg_0 (.a(4'd15), .y(a_neg0));
//     gf_power      u_alpha_neg_1 (.a(4'd14), .y(a_neg1));
//     gf_power      u_alpha_neg_2 (.a(4'd13), .y(a_neg2));
//     gf_power      u_alpha_neg_3 (.a(4'd12), .y(a_neg3));
//     gf_power      u_alpha_neg_4 (.a(4'd11), .y(a_neg4));
//     gf_power      u_alpha_neg_5 (.a(4'd10), .y(a_neg5));
//     gf_power      u_alpha_neg_6 (.a(4'd09), .y(a_neg6));
//     gf_power      u_alpha_neg_7 (.a(4'd08), .y(a_neg7));
//     gf_power      u_alpha_neg_8 (.a(4'd07), .y(a_neg8));
//     gf_power      u_alpha_neg_9 (.a(4'd06), .y(a_neg9));
//     gf_power      u_alpha_neg_a (.a(4'd05), .y(a_nega));
//     gf_power      u_alpha_neg_b (.a(4'd04), .y(a_negb));
//     gf_power      u_alpha_neg_c (.a(4'd03), .y(a_negc));
//     gf_power      u_alpha_neg_d (.a(4'd02), .y(a_negd));
//     gf_power      u_alpha_neg_e (.a(4'd01), .y(a_nege));

//     always_comb begin

//         sum_0 = 4'd1 ^ mult2_0 ^ mult3_0;
//         sum_1 = 4'd1 ^ mult2_1 ^ mult3_1;
//         sum_2 = 4'd1 ^ mult2_2 ^ mult3_2;
//         sum_3 = 4'd1 ^ mult2_3 ^ mult3_3;
//         sum_4 = 4'd1 ^ mult2_4 ^ mult3_4;
//         sum_5 = 4'd1 ^ mult2_5 ^ mult3_5;
//         sum_6 = 4'd1 ^ mult2_6 ^ mult3_6;
//         sum_7 = 4'd1 ^ mult2_7 ^ mult3_7;
//         sum_8 = 4'd1 ^ mult2_8 ^ mult3_8;
//         sum_9 = 4'd1 ^ mult2_9 ^ mult3_9;
//         sum_a = 4'd1 ^ mult2_a ^ mult3_a;
//         sum_b = 4'd1 ^ mult2_b ^ mult3_b;
//         sum_c = 4'd1 ^ mult2_c ^ mult3_c;
//         sum_d = 4'd1 ^ mult2_d ^ mult3_d;
//         sum_e = 4'd1 ^ mult2_e ^ mult3_e;

//         error_vector[0]  = (sum_0 == 4'd0) ? (1'b1) : (1'b0);
//         error_vector[1]  = (sum_1 == 4'd0) ? (1'b1) : (1'b0);
//         error_vector[2]  = (sum_2 == 4'd0) ? (1'b1) : (1'b0);
//         error_vector[3]  = (sum_3 == 4'd0) ? (1'b1) : (1'b0);
//         error_vector[4]  = (sum_4 == 4'd0) ? (1'b1) : (1'b0);
//         error_vector[5]  = (sum_5 == 4'd0) ? (1'b1) : (1'b0);
//         error_vector[6]  = (sum_6 == 4'd0) ? (1'b1) : (1'b0);
//         error_vector[7]  = (sum_7 == 4'd0) ? (1'b1) : (1'b0);
//         error_vector[8]  = (sum_8 == 4'd0) ? (1'b1) : (1'b0);
//         error_vector[9]  = (sum_9 == 4'd0) ? (1'b1) : (1'b0);
//         error_vector[10] = (sum_a == 4'd0) ? (1'b1) : (1'b0);
//         error_vector[11] = (sum_b == 4'd0) ? (1'b1) : (1'b0);
//         error_vector[12] = (sum_c == 4'd0) ? (1'b1) : (1'b0);
//         error_vector[13] = (sum_d == 4'd0) ? (1'b1) : (1'b0);
//         error_vector[14] = (sum_e == 4'd0) ? (1'b1) : (1'b0);
//     end

//     // Check if error found
//     assign error_found = |error_vector;  // Set error_found if any bit is set in error_vector

// endmodule
