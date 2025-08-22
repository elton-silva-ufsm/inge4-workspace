# Setup clock and reset as ideal net and add slew and uncertainty
# Design Constraints
set main_clk clk
set main_rst rst
set period_clk 50 ; #clk = 10.00 MHz = 100 ns (period)

set clk_uncertainty 2 ;# ns ("a guess") jitter + 
set clk_latency 0.35 ;# ns ("a guess")

set in_delay 5.0 ;# ns ("a guess too")
set out_delay 10.0 ;# ns ("a guess too")

set out_load 3 ;#pF ("a guess too")
set in_load 3 ;#pF ("a guess too")

set slew "150 180 300 350" ;#minimum rise, minimum fall, maximum rise and maximum fall 
set slew_min_rise 0.15 ;# ns
set slew_min_fall 0.18 ;# ns
set slew_max_rise 0.30 ;# ns
set slew_max_fall 0.35 ;# ns

set sdc_version 1.5
current_design ${design}

set_load -pin_load ${out_load} [get_ports [all_outputs]]

set input_list [get_ports]

if { [lsearch $input_list $main_clk] != -1 } {
    set_ideal_net [get_nets ${main_clk}]
    create_clock -name ${main_clk} -period $period_clk [get_ports ${main_clk}]
    set_clock_uncertainty ${clk_uncertainty} [get_clocks ${main_clk}]
    set_clock_latency ${clk_latency} [get_clocks ${main_clk}]

    set_input_transition -rise -min $slew_min_rise [remove_from_collection [all_inputs] "[get_ports ${main_clk}]"]
    set_input_transition -fall -min $slew_min_fall [remove_from_collection [all_inputs] "[get_ports ${main_clk}]"]

    set_input_transition -rise -max $slew_max_rise [remove_from_collection [all_inputs] "[get_ports ${main_clk}]"]
    set_input_transition -fall -max $slew_max_fall [remove_from_collection [all_inputs] "[get_ports ${main_clk}]"]

    set_input_delay -clock [get_clocks ${main_clk}] ${in_delay} [remove_from_collection [all_inputs] "[get_ports ${main_clk}]"]
    set_output_delay -clock [get_clocks ${main_clk}] ${out_delay} [all_outputs]
}


if { [lsearch $input_list $main_rst] != -1 } {
    set_ideal_net [get_nets ${main_rst}]
}