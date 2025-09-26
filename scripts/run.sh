#hi again

clear

export ROOT=$(pwd)

module load lic/lic_gmicro
module load cdn/xcelium/xcelium2409 
module load cdn/genus/genus211 
module load cdn/innovus/innovus211 

# Use 64-bits Cadence Tools
export CDS_AUTO_64BIT="ALL"
export PDK_PATH="/home/tools/design_kits/cadence/GPDK045"

export lyt="${ROOT}/layout"
export logs="${ROOT}/logs"
export scr="${ROOT}/scripts"
export src="${ROOT}/src"
export lib="${ROOT}/lib"
export tests="${ROOT}/src/tests"
export syn="${ROOT}/synthesis"
export cons="${ROOT}/constraints"
export custom="${ROOT}/custom"

export work_dir="${ROOT}/work"
export rpt="${ROOT}/synthesis/reports"
#------------------------------------
# export design="and16"
# export design="or16"
# export design="syndrome_block_se"
# export design="h_decoder_11_7"
# export design="bch_syndrome_block"
# export design="bch_bm_block"
# export design="bch_chien_block"
# export design="bch_toplevel"
# export design="bch_bm_block_p"
# export design="bm_stage_1"
# export design="bm_stage_2"
# export design="bm_stage_3"
export design="bch_pipelined"
#------------------------------------

if [ ! -d "$work_dir" ]; then
  mkdir -p "$work_dir"
fi
cd $work_dir

case ${1} in
  x)
    xrun -clean
    echo -e "\033[1;33mExecuting logical simulation...\033[0m"
    xrun -f ${scr}/xrun.conf
  ;;
  xs)
    xrun -clean
    echo -e "\033[1;33mExecuting logical simulation...\033[0m"
    xrun -f ${scr}/xrun_syn.conf
  ;;
  xl)
    xrun -clean
    echo -e "\033[1;33mExecuting logical simulation...\033[0m"
    xrun -f ${scr}/xrun_lyt.conf 
  ;;
  xg)
    xrun -clean
    echo -e "\033[1;33mExecuting logical simulation...\033[0m"
    xrun -gui -f ${scr}/xrun.conf
  ;;
  xc)
    echo -e "\033[1;33mCompiling HDL...\033[0m"
    xrun -compile ${src}/${design}.sv ${tests}/${design}_tb.sv
  ;;
  xe)
    echo -e "\033[1;33mCompiling HDL...\033[0m"
    xrun -elaborate ${src}/${design}.sv ${tests}/${design}_tb.sv
  ;;
  b)
    xrun -clean 
    echo -e "\033[1;33mExecuting BCH logical simulation...\033[0m"
    # xrun ${src}/memory.sv \
    # xrun ${src}/bch_encoder.sv \
    # xrun ${src}/h_encoder_11_7.sv \
    # xrun ${src}/test_decoder_bch.sv \
    xrun ${src}/error_generator5.sv \
    -access +rw -nohistory -quiet -sv \
    -log ${logs}/xrun.log -timescale 1ns/10ps # -gui
  ;;
  
  g)
    echo -e "\033[1;33mExecuting logic synthesis...\033[0m"
    genus -a -o -logs "${logs}/genus.log /dev/null" \
    -f ${scr}/logic_synt.tcl
  ;;

  i)
    echo -e "\033[1;33mExecuting pyshical synthesis...\033[0m";
    innovus -stylus -abort_on_error -overwrite -log "${logs}/innovus.log /dev/null" \
    -files ${scr}/phy_synt.tcl
  ;;
  ii)
    echo -e "\033[1;33mExecuting pyshical synthesis...\033[0m";
    innovus -stylus -abort_on_error -overwrite -db ${design}.enc
  ;;
  all)
    echo -e "\033[1;33mExecuting logical simulation...\033[0m"
    xrun -f ${scr}/xrun.conf
    
    echo -e "\033[1;33mExecuting logic synthesis...\033[0m"
    genus -a -o -b -logs "${logs}/genus.log /dev/null" \
    -f ${scr}/logic_synt.tcl
    
    echo -e "\033[1;33mExecuting pyshical synthesis...\033[0m";
    innovus -stylus -abort_on_error -overwrite -log "${logs}/innovus.log /dev/null" \
    -files ${scr}/phy_synt.tcl
  ;;

  *)
    echo "Missing an argument: usage: ${0} <tool_opt: x|xs|g|i|all>"
esac
