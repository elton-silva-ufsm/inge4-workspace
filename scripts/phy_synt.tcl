#------------------------------------
gui_show
set ROOT $env(ROOT)
set PDK_PATH $env(PDK_PATH)

set custom $env(custom)
set lyt $env(lyt)
set logs $env(logs)
set scr $env(scr)
set tests $env(tests)
set syn $env(syn)
set src $env(src)
set rpt $env(rpt)
set cons $env(cons)
set qrc_path "$PDK_PATH/gpdk045_v_6_0/qrc/"
set lib_path "$PDK_PATH/gsclib045_all_v4.4/gsclib045/timing/"

set design $env(design)

if {![file exists ${lyt}/${design}]} {
    file mkdir ${lyt}/${design}
}
#------------------------------------ [01]
set_db init_power_nets VDD
set_db init_ground_nets VSS
#------------------------------------ [02]
switch $design {
   "especifico" {
   }
   default {
      read_mmmc $cons/basic.view
   }
}
#------------------------------------ [03]
switch $design {
   "especifico" {
   }
   default {
      # PADS ${PDK_PATH}/giolib045_v3.3/lef/giolib045.lef
      read_physical -lef "${PDK_PATH}/gsclib045_svt_v4.4/gsclib045/lef/gsclib045_tech.lef ${PDK_PATH}/gsclib045_svt_v4.4/gsclib045/lef/gsclib045_macro.lef"
   }
}
#------------------------------------ [04]
switch $design {
   "especifico" {
   }
   default {
      read_netlist $syn/$design/$design.v
   }
}
#------------------------------------ [05]
init_design
#------------------------------------ [06]
switch $design {
   "especifico" {
   }
   default {
      connect_global_net VDD -type pg_pin -pin_base_name VDD -inst_base_name *
      connect_global_net VSS -type pg_pin -pin_base_name VSS -inst_base_name *
   }
}
#------------------------------------ [07]
set_db design_process_node 45
#------------------------------------ [08]
switch $design {
   "bch_toplevel" {
      create_floorplan -core_density_size 1 0.95 3 3 3 3
   }
   default {
		# 																		rat den l b r t
      create_floorplan -core_density_size 4 0.9 3 3 3 3
   }
}

#------------------------------------ [09]
set_db add_rings_skip_shared_inner_ring none
set_db add_rings_avoid_short 1
set_db add_rings_ignore_rows 0
set_db add_rings_extend_over_row 0

switch $design {
   "especifico" {
   }
   default {
      # add_rings -type core_rings -jog_distance 0.6 -threshold 0.6 -nets "VDD VSS" -follow core -layer {bottom Metal4 top Metal4 right Metal3 left Metal3} -width 0.7 -spacing 0.4 -offset .6
      add_rings -type core_rings -jog_distance 0.6 -threshold 0.6 -nets "VDD VSS" -follow core -layer {bottom Metal11 top Metal11 right Metal10 left Metal10} -width 0.7 -spacing 0.4 -offset 0.6
   }
}

# suspend
#------------------------------------ [10]
switch $design {
	"and16" {
	}
   "or16" {
	}
   "h_decoder_11_7" {
   }
   "syndrome_block_se" {
   }
	default {
	# add_stripes -block_ring_top_layer_limit Metal4 -max_same_layer_jog_length 0.44 -set_to_set_distance 7 -pad_core_ring_top_layer_limit Metal4 -spacing 0.4 -layer Metal3 -width 0.28 -start_offset 1 -nets "VDD VSS"
	add_stripes -block_ring_top_layer_limit Metal11 -max_same_layer_jog_length 0.44 -set_to_set_distance 7 -pad_core_ring_top_layer_limit Metal11 -spacing 0.4 -layer Metal10 -width 0.22 -start_offset 1 -nets "VDD VSS"
   }
}

#------------------------------------ [11]
switch $design {
  "especifico" {
  }
	default {
		# route_special -layer_change_range {Metal1(1) Metal4(4)} -block_pin_target nearest_target -allow_jogging 1 -crossover_via_layer_range {Metal1(1) Metal4(4)} -nets "VDD VSS" -allow_layer_change 1 -target_via_layer_range {Metal1(1) Metal4(4)}
      route_special -layer_change_range {Metal1(1) Metal11(11)} -block_pin_target nearest_target -allow_jogging 1 -crossover_via_layer_range {Metal1(1) Metal11(11)} -nets "VDD VSS" -allow_layer_change 1 -target_via_layer_range {Metal1(1) Metal11(11)}
  }
}

#------------------------------------ [12]
if {[file exists $scr/pins/${design}_pin.tcl]} {
   source $scr/pins/${design}_pin.tcl
} else {
   set_db place_global_place_io_pins 1
}

gui_fit
# suspend

#------------------------------------ [14]
place_design

#------------------------------------ [15]
set_db extract_rc_engine pre_route
extract_rc
#------------------------------------ [16]
# set_db opt_drv_fix_max_cap true ; set_db opt_drv_fix_max_tran true ; set_db opt_fix_fanout_load false
# opt_design -pre_cts
#------------------------------------ [17]
route_design
#------------------------------------ [18]
# set_db timing_analysis_type ocv
# time_design -post_route >> $lyt/reports/${design}_tns.rpt 
# set_interactive_constraint_modes {basic_constraint}
# set_propagated_clock [all_clocks] 
#------------------------------------ [19]
add_fillers -base_cells {FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1}
#------------------------------------ [20]
check_drc
delete_routes -regular_wire_with_drc ;# command to delete routed nets with DRC violations

route_design

check_drc
route_eco -fix_drc ;# tries to fix remaining violation nets
check_drc
# delete_routes -layer 6
#  -route_only_layers 4:5;# route_only_layers option restricts eco routing to specified layer range 
# check_drc

#------------------------------------ [21]
# add_metal_fill -layers {Metal1 Metal2 Metal3 Metal4}

#------------------------------------ [22]
check_antenna
puts "SALVAR DESIGN?"
suspend
write_netlist $lyt/${design}/${design}_lyt.v
write_sdf -edge check_edge -map_setuphold merge_always -map_recrem merge_always -version 3.0  $lyt/${design}/${design}_lyt.sdf
get_db power_method
report_power -power_unit uW > $lyt/${design}/reports/${design}_pwr.rpt
set_db power_corner min
#   write_stream -mode ALL -unit 2000 $lyt/${design}.gsd
write_def -floorplan -netlist -routing $lyt/${design}/${design}_lyt.def
report_area > $lyt/${design}/reports/${design}_area.rpt
report_timing -unconstrained > $lyt/${design}/reports/${design}_timing.rpt
write_db $design.enc
gui_fit
gui_create_floorplan_snapshot -dir $ROOT/pics/$design/ -name $design.png -overwrite
set_db timing_analysis_check_type hold
report_timing -unconstrained > $lyt/${design}/reports/${design}_hold_timing.rpt
set_db timing_analysis_check_type setup
report_timing -unconstrained > $lyt/${design}/reports/${design}_setup_timing.rpt

exit