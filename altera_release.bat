@echo off
mkdir release\altera_sopc\POWERLINK\src
mkdir release\altera_sopc\POWERLINK\src\lib 
mkdir release\altera_sopc\POWERLINK\sdc
mkdir release\altera_sopc\POWERLINK\doc
mkdir release\altera_sopc\hex

copy active_hdl\src\hex\*.hex						release\altera_sopc\hex
copy active_hdl\src\*.vhd							release\altera_sopc\POWERLINK\src
copy active_hdl\src\lib\*.vhd						release\altera_sopc\POWERLINK\src\lib
copy active_hdl\src\openMAC_DMAmaster\*.vhd			release\altera_sopc\POWERLINK\src\openMAC_DMAmaster
copy active_hdl\compile\*.vhd						release\altera_sopc\POWERLINK\src
copy active_hdl\src\altera_sopc\powerlink_hw.tcl	release\altera_sopc\POWERLINK
copy active_hdl\src\altera_sopc\*.sdc				release\altera_sopc\POWERLINK\sdc
copy documentation\*_Generic.pdf					release\altera_sopc\POWERLINK\doc
copy documentation\*_Altera.pdf						release\altera_sopc\POWERLINK\doc
copy documentation\OpenMAC.pdf						release\altera_sopc\POWERLINK\doc

del release\altera_sopc\POWERLINK\src\*_TB.vhd
del release\altera_sopc\POWERLINK\src\*_Xilinx.vhd
del release\altera_sopc\POWERLINK\src\openMAC_DMAmaster\plb_master_handler.vhd
del release\altera_sopc\POWERLINK\src\plb_powerlink.vhd

@echo on