
################################################################
# This is a generated script based on design: main_block_design
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source main_block_design_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z010clg400-1
}


# CHANGE DESIGN NAME HERE
set design_name main_block_design

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set hdmi_in_ddc [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 hdmi_in_ddc ]

  # Create ports
  set hdmi_hpd [ create_bd_port -dir O -from 0 -to 0 hdmi_hpd ]
  set hdmi_in_clk_n [ create_bd_port -dir I -type clk hdmi_in_clk_n ]
  set hdmi_in_clk_p [ create_bd_port -dir I -type clk hdmi_in_clk_p ]
  set hdmi_in_data_n [ create_bd_port -dir I -from 2 -to 0 hdmi_in_data_n ]
  set hdmi_in_data_p [ create_bd_port -dir I -from 2 -to 0 hdmi_in_data_p ]
  set hdmi_out_en [ create_bd_port -dir O -from 0 -to 0 hdmi_out_en ]
  set sys_clock [ create_bd_port -dir I -type clk sys_clock ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {125000000} \
 ] $sys_clock
  set vga_b [ create_bd_port -dir O -from 4 -to 0 vga_b ]
  set vga_g [ create_bd_port -dir O -from 5 -to 0 vga_g ]
  set vga_hs [ create_bd_port -dir O vga_hs ]
  set vga_r [ create_bd_port -dir O -from 4 -to 0 vga_r ]
  set vga_vs [ create_bd_port -dir O vga_vs ]

  # Create instance: RGB_pack_0, and set properties
  set RGB_pack_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:RGB_pack:1.0 RGB_pack_0 ]

  # Create instance: RGB_unpack_0, and set properties
  set RGB_unpack_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:RGB_unpack:1.0 RGB_unpack_0 ]

  # Create instance: clk_wiz, and set properties
  set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.4 clk_wiz ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {80.0} \
CONFIG.CLKOUT1_DRIVES {BUFG} \
CONFIG.CLKOUT1_JITTER {109.241} \
CONFIG.CLKOUT1_PHASE_ERROR {96.948} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
CONFIG.CLKOUT2_DRIVES {BUFG} \
CONFIG.CLKOUT3_DRIVES {BUFG} \
CONFIG.CLKOUT4_DRIVES {BUFG} \
CONFIG.CLKOUT5_DRIVES {BUFG} \
CONFIG.CLKOUT6_DRIVES {BUFG} \
CONFIG.CLKOUT7_DRIVES {BUFG} \
CONFIG.MMCM_CLKFBOUT_MULT_F {8} \
CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {5} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.PRIMITIVE {PLL} \
CONFIG.PRIM_IN_FREQ {125.000} \
CONFIG.USE_LOCKED {false} \
CONFIG.USE_RESET {false} \
 ] $clk_wiz

  # Create instance: dvi2rgb_0, and set properties
  set dvi2rgb_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:dvi2rgb:1.8 dvi2rgb_0 ]
  set_property -dict [ list \
CONFIG.kClkRange {3} \
CONFIG.kEdidFileName {dgl_720p_cea.data} \
 ] $dvi2rgb_0

  # Create instance: rgb2vga_0, and set properties
  set rgb2vga_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2vga:1.0 rgb2vga_0 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net dvi2rgb_0_DDC [get_bd_intf_ports hdmi_in_ddc] [get_bd_intf_pins dvi2rgb_0/DDC]

  # Create port connections
  connect_bd_net -net RGB_pack_0_out_DE [get_bd_pins RGB_pack_0/out_DE] [get_bd_pins rgb2vga_0/rgb_pVDE]
  connect_bd_net -net RGB_pack_0_out_HSync [get_bd_pins RGB_pack_0/out_HSync] [get_bd_pins rgb2vga_0/rgb_pHSync]
  connect_bd_net -net RGB_pack_0_out_PClk [get_bd_pins RGB_pack_0/out_PClk] [get_bd_pins rgb2vga_0/PixelClk]
  connect_bd_net -net RGB_pack_0_out_RGB [get_bd_pins RGB_pack_0/out_RGB] [get_bd_pins rgb2vga_0/rgb_pData]
  connect_bd_net -net RGB_pack_0_out_VSync [get_bd_pins RGB_pack_0/out_VSync] [get_bd_pins rgb2vga_0/rgb_pVSync]
  connect_bd_net -net RGB_unpack_0_out_B [get_bd_pins RGB_pack_0/in_B] [get_bd_pins RGB_unpack_0/out_B]
  connect_bd_net -net RGB_unpack_0_out_DE [get_bd_pins RGB_pack_0/in_DE] [get_bd_pins RGB_unpack_0/out_DE]
  connect_bd_net -net RGB_unpack_0_out_G [get_bd_pins RGB_pack_0/in_G] [get_bd_pins RGB_unpack_0/out_G]
  connect_bd_net -net RGB_unpack_0_out_HSync [get_bd_pins RGB_pack_0/in_HSync] [get_bd_pins RGB_unpack_0/out_HSync]
  connect_bd_net -net RGB_unpack_0_out_PClk [get_bd_pins RGB_pack_0/in_PClk] [get_bd_pins RGB_unpack_0/out_PClk]
  connect_bd_net -net RGB_unpack_0_out_R [get_bd_pins RGB_pack_0/in_R] [get_bd_pins RGB_unpack_0/out_R]
  connect_bd_net -net RGB_unpack_0_out_VSync [get_bd_pins RGB_pack_0/in_VSync] [get_bd_pins RGB_unpack_0/out_VSync]
  connect_bd_net -net clk_wiz_clk_out1 [get_bd_pins clk_wiz/clk_out1] [get_bd_pins dvi2rgb_0/RefClk]
  connect_bd_net -net dvi2rgb_0_PixelClk [get_bd_pins RGB_unpack_0/in_PClk] [get_bd_pins dvi2rgb_0/PixelClk]
  connect_bd_net -net dvi2rgb_0_vid_pData [get_bd_pins RGB_unpack_0/in_RGB] [get_bd_pins dvi2rgb_0/vid_pData]
  connect_bd_net -net dvi2rgb_0_vid_pHSync [get_bd_pins RGB_unpack_0/in_HSync] [get_bd_pins dvi2rgb_0/vid_pHSync]
  connect_bd_net -net dvi2rgb_0_vid_pVDE [get_bd_pins RGB_unpack_0/in_DE] [get_bd_pins dvi2rgb_0/vid_pVDE]
  connect_bd_net -net dvi2rgb_0_vid_pVSync [get_bd_pins RGB_unpack_0/in_VSync] [get_bd_pins dvi2rgb_0/vid_pVSync]
  connect_bd_net -net hdmi_in_clk_n_1 [get_bd_ports hdmi_in_clk_n] [get_bd_pins dvi2rgb_0/TMDS_Clk_n]
  connect_bd_net -net hdmi_in_clk_p_1 [get_bd_ports hdmi_in_clk_p] [get_bd_pins dvi2rgb_0/TMDS_Clk_p]
  connect_bd_net -net hdmi_in_data_n_1 [get_bd_ports hdmi_in_data_n] [get_bd_pins dvi2rgb_0/TMDS_Data_n]
  connect_bd_net -net hdmi_in_data_p_1 [get_bd_ports hdmi_in_data_p] [get_bd_pins dvi2rgb_0/TMDS_Data_p]
  connect_bd_net -net rgb2vga_0_vga_pBlue [get_bd_ports vga_b] [get_bd_pins rgb2vga_0/vga_pBlue]
  connect_bd_net -net rgb2vga_0_vga_pGreen [get_bd_ports vga_g] [get_bd_pins rgb2vga_0/vga_pGreen]
  connect_bd_net -net rgb2vga_0_vga_pHSync [get_bd_ports vga_hs] [get_bd_pins rgb2vga_0/vga_pHSync]
  connect_bd_net -net rgb2vga_0_vga_pRed [get_bd_ports vga_r] [get_bd_pins rgb2vga_0/vga_pRed]
  connect_bd_net -net rgb2vga_0_vga_pVSync [get_bd_ports vga_vs] [get_bd_pins rgb2vga_0/vga_pVSync]
  connect_bd_net -net sys_clock_1 [get_bd_ports sys_clock] [get_bd_pins clk_wiz/clk_in1]
  connect_bd_net -net xlconstant_0_dout [get_bd_ports hdmi_out_en] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_ports hdmi_hpd] [get_bd_pins xlconstant_1/dout]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


