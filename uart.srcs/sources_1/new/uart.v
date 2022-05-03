`timescale 1ns / 1ps



module uart_tx(
    input sys_clk_in,
    input sys_rst_n,
    input [3:0] Baud_set,
    output uart_tx,
    output led_tx
    );

    wire clk_50mhz;
    wire clk_100mhz;
    wire rst;
    wire fifo_full;
    wire fifo_empty;
    wire fifo_wr_en;
    wire fifo_rd_en;
    wire [7:0] gen_data;
    wire [7:0] uart_data;


    assign rst = ~rst_n;

  clk_pll instance1
   (
        // Clock out ports
        .clk_50mhz(clk_50mhz),     // output clk_50mhz
        .clk_100mhz(clk_100mhz),     // output clk_100mhz
        // Status and control signals
        .resetn(sys_rst_n), // input resetn
        .locked(rst_n),       // output locked
        // Clock in ports
        .sys_clk_in(sys_clk_in)
    );      // input sys_clk_in

    data_gen instance2
    (
        .clk(clk_50mhz),
        .rst(rst),
        .full(fifo_full),
        .wr_en(fifo_wr_en),
        .gen_data(gen_data)
    );

    fifo_gen instance3 
    (
        .rst(rst),        // input wire rst
        .wr_clk(clk_50mhz),  // input wire wr_clk
        .rd_clk(clk_100mhz),  // input wire rd_clk
        .din(gen_data),        // input wire [7 : 0] din
        .wr_en(fifo_wr_en),    // input wire wr_en
        .rd_en(fifo_rd_en),    // input wire rd_en
        .dout(uart_data),      // output wire [7 : 0] dout
        .full(fifo_full),      // output wire full
        .empty(fifo_empty)    // output wire empty
    );


    uart_utils instance4
    (
        .clk(clk_100mhz),
        .rst(rst),
        .Baud_set(Baud_set),
        .empty(fifo_empty),
        .rd_en(fifo_rd_en),
        .uart_data(uart_data),
        .led_tx(led_tx),
        .uart_tx(uart_tx)
    );

endmodule
