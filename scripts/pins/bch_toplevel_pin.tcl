set pin_l "codeword[14] codeword[13] codeword[12] codeword[11] codeword[10] 
           codeword[9]  codeword[8]  codeword[7]  codeword[6]  codeword[5] 
           codeword[4]  codeword[3]  codeword[2]  codeword[1]  codeword[0]"
set spc_l "1.5"

set pin_t "clk rst
           lambda1_out[3] lambda1_out[2] lambda1_out[1] lambda1_out[0] 
           lambda2_out[3] lambda2_out[2] lambda2_out[1] lambda2_out[0]
           S1_out[3]      S1_out[2]      S1_out[1]      S1_out[0] 
           S2_out[3]      S2_out[2]      S2_out[1]      S2_out[0] 
           S3_out[3]      S3_out[2]      S3_out[1]      S3_out[0]"
set spc_t "1.5"

set pin_r "corrected_codeword[14] corrected_codeword[13] corrected_codeword[12] corrected_codeword[11] corrected_codeword[10] 
           corrected_codeword[9]  corrected_codeword[8]  corrected_codeword[7]  corrected_codeword[6]  corrected_codeword[5] 
           corrected_codeword[4]  corrected_codeword[3]  corrected_codeword[2]  corrected_codeword[1]  corrected_codeword[0]"
set spc_r "1.5"

set pin_b "error_vector_out[14] error_vector_out[13] error_vector_out[12] error_vector_out[11] error_vector_out[10] 
           error_vector_out[9]  error_vector_out[8]  error_vector_out[7]  error_vector_out[6]  error_vector_out[5] 
           error_vector_out[4]  error_vector_out[3]  error_vector_out[2]  error_vector_out[1]  error_vector_out[0] 
           error_flag"
set spc_b "1.5"

set_db assign_pins_edit_in_batch true

if {[info exists pin_l] && [string length $pin_l] > 0} {
    edit_pin -pin $pin_l -spread_type center -edge 0 -layer Metal2 -fix_overlap 1 -spacing $spc_l -pin_width 0.08 -fixed_pin 1
}
if {[info exists pin_t] && [string length $pin_t] > 0} {
    edit_pin -pin $pin_t -spread_type center -edge 1 -layer Metal3 -fix_overlap 1 -spacing $spc_t -pin_width 0.08 -fixed_pin 1
}
if {[info exists pin_r] && [string length $pin_r] > 0} {
    edit_pin -pin $pin_r -spread_type center -edge 2 -layer Metal2 -fix_overlap 1 -spacing $spc_r -pin_width 0.08 -fixed_pin 1
}
if {[info exists pin_b] && [string length $pin_b] > 0} {
    edit_pin -pin $pin_b -spread_type center -edge 3 -layer Metal3 -fix_overlap 1 -spacing $spc_b -pin_width 0.08 -fixed_pin 1

}
set_db assign_pins_edit_in_batch false
