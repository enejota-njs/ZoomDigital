set_global_assignment -entity "clock_75MHz" -library "lib_clock_75MHz" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "clock_75MHz" -library "lib_clock_75MHz" -name IP_TOOL_VERSION "19.1"
set_global_assignment -entity "clock_75MHz" -library "lib_clock_75MHz" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_clock_75MHz" -name SPD_FILE [file join $::quartus(sip_path) "clock_75MHz.spd"]

set_global_assignment -library "lib_clock_75MHz" -name MISC_FILE [file join $::quartus(sip_path) "clock_75MHz_sim/clock_75MHz.vo"]
