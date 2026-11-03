## =========================================================
## CLOCK
## =========================================================

set_property -dict { PACKAGE_PIN N11 IOSTANDARD LVCMOS33 } [get_ports {clk}]
create_clock -period 20.000 -name sys_clk [get_ports {clk}]


## =========================================================
## CAPACITIVE TOUCH INPUTS
## =========================================================

## DOT - OUT1
set_property -dict { PACKAGE_PIN P14 IOSTANDARD LVCMOS33 PULLDOWN true } [get_ports {pb_dot}]

## DASH - OUT2
set_property -dict { PACKAGE_PIN P10 IOSTANDARD LVCMOS33 PULLDOWN true } [get_ports {pb_dash}]

## ENTER - OUT3
set_property -dict { PACKAGE_PIN P11 IOSTANDARD LVCMOS33 PULLDOWN true } [get_ports {pb_enter}]

## SPACE - OUT4
set_property -dict { PACKAGE_PIN R12 IOSTANDARD LVCMOS33 PULLDOWN true } [get_ports {pb_space}]


## =========================================================
## PHYSICAL PUSH BUTTONS
## =========================================================

## DELETE
set_property -dict { PACKAGE_PIN M14 IOSTANDARD LVCMOS33 PULLDOWN true } [get_ports {pb_delete}]

## CLEAR
set_property -dict { PACKAGE_PIN K13 IOSTANDARD LVCMOS33 PULLDOWN true } [get_ports {pb_clear}]

## =========================================================
## LCD DATA BUS
## =========================================================

set_property -dict { PACKAGE_PIN P3 IOSTANDARD LVCMOS33 } [get_ports {lcd_data[7]}]
set_property -dict { PACKAGE_PIN M5 IOSTANDARD LVCMOS33 } [get_ports {lcd_data[6]}]
set_property -dict { PACKAGE_PIN N4 IOSTANDARD LVCMOS33 } [get_ports {lcd_data[5]}]
set_property -dict { PACKAGE_PIN R2 IOSTANDARD LVCMOS33 } [get_ports {lcd_data[4]}]
set_property -dict { PACKAGE_PIN R1 IOSTANDARD LVCMOS33 } [get_ports {lcd_data[3]}]
set_property -dict { PACKAGE_PIN R3 IOSTANDARD LVCMOS33 } [get_ports {lcd_data[2]}]
set_property -dict { PACKAGE_PIN T2 IOSTANDARD LVCMOS33 } [get_ports {lcd_data[1]}]
set_property -dict { PACKAGE_PIN T4 IOSTANDARD LVCMOS33 } [get_ports {lcd_data[0]}]

## LCD Enable
set_property -dict { PACKAGE_PIN T3 IOSTANDARD LVCMOS33 } [get_ports {lcd_e}]

## LCD Register Select
set_property -dict { PACKAGE_PIN P5 IOSTANDARD LVCMOS33 } [get_ports {lcd_rs}]


## =========================================================
## DEBUG LEDs
## =========================================================

set_property -dict { PACKAGE_PIN J3  IOSTANDARD LVCMOS33 } [get_ports {led[0]}]
set_property -dict { PACKAGE_PIN H3  IOSTANDARD LVCMOS33 } [get_ports {led[1]}]
set_property -dict { PACKAGE_PIN J1  IOSTANDARD LVCMOS33 } [get_ports {led[2]}]
set_property -dict { PACKAGE_PIN K1  IOSTANDARD LVCMOS33 } [get_ports {led[3]}]
set_property -dict { PACKAGE_PIN L3  IOSTANDARD LVCMOS33 } [get_ports {led[4]}]
set_property -dict { PACKAGE_PIN L2  IOSTANDARD LVCMOS33 } [get_ports {led[5]}]
set_property -dict { PACKAGE_PIN K3  IOSTANDARD LVCMOS33 } [get_ports {led[6]}]
set_property -dict { PACKAGE_PIN K2  IOSTANDARD LVCMOS33 } [get_ports {led[7]}]
set_property -dict { PACKAGE_PIN K5  IOSTANDARD LVCMOS33 } [get_ports {led[8]}]
set_property -dict { PACKAGE_PIN P6  IOSTANDARD LVCMOS33 } [get_ports {led[9]}]
set_property -dict { PACKAGE_PIN R7  IOSTANDARD LVCMOS33 } [get_ports {led[10]}]
set_property -dict { PACKAGE_PIN R6  IOSTANDARD LVCMOS33 } [get_ports {led[11]}]
set_property -dict { PACKAGE_PIN T5  IOSTANDARD LVCMOS33 } [get_ports {led[12]}]
set_property -dict { PACKAGE_PIN R5  IOSTANDARD LVCMOS33 } [get_ports {led[13]}]
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports {led[14]}]
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports {led[15]}]
