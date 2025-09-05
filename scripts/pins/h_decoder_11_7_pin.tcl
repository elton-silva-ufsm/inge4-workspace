# Define pinos para cada lado (pode deixar vazio)
set pin_l "i_CodeWord[11] i_CodeWord[10] i_CodeWord[9] i_CodeWord[8] i_CodeWord[7] i_CodeWord[6] i_CodeWord[5] i_CodeWord[4] i_CodeWord[3] i_CodeWord[2] i_CodeWord[1] i_CodeWord[0]"
set spc_l "0.5"

set pin_t ""
set spc_t ""

set pin_r "o_DecodWord[6] o_DecodWord[5] o_DecodWord[4] o_DecodWord[3] o_DecodWord[2] o_DecodWord[1] o_DecodWord[0] o_Syndrome[4] o_Syndrome[3] o_Syndrome[2] o_Syndrome[1] o_Syndrome[0] o_ErrorFlag"
set spc_r "0.5"

set pin_b ""
set spc_b ""

set_db assign_pins_edit_in_batch true

if {[info exists pin_l] && [string length $pin_l] > 0} {
    edit_pin -pin $pin_l -spread_type center -edge 0 -layer Metal3 -fix_overlap 1 -spacing $spc_l -fixed_pin 1 -pin_width 0.08
}
if {[info exists pin_t] && [string length $pin_t] > 0} {
    edit_pin -pin $pin_t -spread_type center -edge 1 -layer Metal2 -fix_overlap 1 -spacing $spc_t -fixed_pin 1 -pin_width 0.08
}
if {[info exists pin_r] && [string length $pin_r] > 0} {
    edit_pin -pin $pin_r -spread_type center -edge 2 -layer Metal3 -fix_overlap 1 -spacing $spc_r -fixed_pin 1 -pin_width 0.08
}
if {[info exists pin_b] && [string length $pin_b] > 0} {
    edit_pin -pin $pin_b -spread_type center -edge 3 -layer Metal2 -fix_overlap 1 -spacing $spc_b -fixed_pin 1 -pin_width 0.08

}
set_db assign_pins_edit_in_batch false
