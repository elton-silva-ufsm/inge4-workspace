
# Logic Synthesis
# It's important to set design variable to correspond to top-level design file name
gui_show

set ROOT $env(ROOT)
set PDK_PATH $env(PDK_PATH)

set lyt $env(lyt)
set logs $env(logs)
set scr $env(scr)
set src $env(src)
set tests $env(tests)
set syn $env(syn)
set rpt $env(rpt)
set cons $env(cons)

set design $env(design)

if {![file exists ${syn}/${design}]} {
    file mkdir ${syn}/${design}
}

set_db auto_ungroup both

switch $design {
   "inter_spartan_spi" {
      read_hdl -sv ../ascon/inter_spartan_spi.sv
    }
    default {
      read_hdl -sv ${src}/${design}.sv
    }
}


read_lib $PDK_PATH/gsclib045_all_v4.4/gsclib045/timing/fast_vdd1v0_basicCells.lib

elaborate
switch $design {
   "inter_spartan_spi" {
      read_sdc $cons/ascon.sdc
    }
    default {
      read_sdc $cons/basic.sdc
    }
}

foreach lc [get_db base_cells -if {.name == "SDF*"}] {
  set_db $lc .dont_use true
}

foreach lc [get_db base_cells -if {.name == "CLKBUF*"}] {
  set_db $lc .dont_use true
}

syn_generic
syn_map
syn_opt

report_area >> ${syn}/${design}/reports/${design}_area.txt
report_gates >> ${syn}/${design}/reports/${design}_gates.txt
report_power >> ${syn}/${design}/reports/${design}_power.txt
# suspend
write_hdl ${design} > ${syn}/${design}/${design}.v
write_sdf -edge check_edge -setuphold merge_always -nonegchecks -recrem split -version 3.0 -design ${design} > ${syn}/${design}/${design}.sdf
# exit