set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports {sys_clk_in} ]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports {sys_rst_n}  ]

set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS33} [get_ports {uart_tx}]

set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {led_tx}]

set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports {Baud_set[0]}]
set_property -dict {PACKAGE_PIN M4 IOSTANDARD LVCMOS33} [get_ports {Baud_set[1]}]
set_property -dict {PACKAGE_PIN N4 IOSTANDARD LVCMOS33} [get_ports {Baud_set[2]}]
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports {Baud_set[3]}]

