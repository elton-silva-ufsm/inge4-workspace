# Define pinos para cada lado (pode deixar vazio)
set pin_l ""
set spc_l ""

set pin_t ""
set spc_t ""

set pin_r "a[0] a[1] a[2] a[3] a[4] a[5] a[6] a[7] a[8] a[9] a[10] a[11] a[12] a[13] a[14] a[15]"
set spc_r "0.5"

set pin_b "y"
set spc_b "1"

set_db assign_pins_edit_in_batch true

if {[info exists pin_l] && [string length $pin_l] > 0} {
    edit_pin -pin $pin_l -spread_type center -edge 0 -layer Metal2 -fix_overlap 1 -spacing $spc_l -unit track -fixed_pin 1
}
if {[info exists pin_t] && [string length $pin_t] > 0} {
    edit_pin -pin $pin_t -spread_type center -edge 1 -layer Metal2 -fix_overlap 1 -spacing $spc_t -unit track -fixed_pin 1
}
if {[info exists pin_r] && [string length $pin_r] > 0} {
    # edit_pin -pin $pin_r -spread_type start -start {14 0} -edge 2 -layer Metal3 -fix_overlap 1 -spacing 1.8 -fixed_pin 1 -pin_width 0.6 -spread_direction counterclockwise
    edit_pin -pin $pin_r -spread_type center -edge 2 -layer Metal3 -fix_overlap 1 -spacing $spc_r -fixed_pin 1 -pin_width 0.08
}
if {[info exists pin_b] && [string length $pin_b] > 0} {
    edit_pin -pin $pin_b -spread_type center -edge 3 -layer Metal2 -fix_overlap 1 -spacing $spc_b -unit track -fixed_pin 1

}
set_db assign_pins_edit_in_batch false
