// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Tue May  3 15:20:37 2022
// Host        : PC04 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/FPGA-proj-master/uart/uart.srcs/sources_1/ip/clk_pll/clk_pll_stub.v
// Design      : clk_pll
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_pll(clk_50mhz, clk_100mhz, resetn, locked, 
  sys_clk_in)
/* synthesis syn_black_box black_box_pad_pin="clk_50mhz,clk_100mhz,resetn,locked,sys_clk_in" */;
  output clk_50mhz;
  output clk_100mhz;
  input resetn;
  output locked;
  input sys_clk_in;
endmodule
