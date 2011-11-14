@echo off

copy active_hdl\src\*.vhd				..\release\altera_sopc\POWERLINK\src
copy active_hdl\src\lib\*.vhd				..\release\altera_sopc\POWERLINK\src\lib
copy active_hdl\src\openMAC_DMAmaster\*.vhd		..\release\altera_sopc\POWERLINK\src\openMAC_DMAmaster
copy active_hdl\compile\*.vhd				..\release\altera_sopc\POWERLINK\src
copy active_hdl\src\altera_sopc\powerlink_hw.tcl	..\release\altera_sopc\POWERLINK
copy active_hdl\src\altera_sopc\*.sdc			..\release\altera_sopc\POWERLINK\sdc
copy documentation\*.pdf				..\release\altera_sopc\POWERLINK\doc

del ..\release\altera_sopc\POWERLINK\src\*_TB.vhd
del ..\release\altera_sopc\POWERLINK\src\*_Xilinx.vhd
del ..\release\altera_sopc\POWERLINK\src\openMAC_DMAmaster\plb_master_handler.vhd

@echo on