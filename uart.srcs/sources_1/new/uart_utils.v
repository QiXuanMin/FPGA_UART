`timescale 1ns / 1ps



module uart_utils(
    input clk,
    input rst,
    input [3:0] Baud_set,
    input empty,
    output reg rd_en,
    input [7:0] uart_data,
    output reg led_tx,
    output reg uart_tx
    );

    parameter   FIFO_IS_EMPTY = 16'd0,
                FIFO_RD_EN = 16'd1,
                FIFO_READ = 16'd2,
                UART_TX_START_BIT = 16'd3,
                UART_TX_BIT0 = 16'd4,
                UART_TX_BIT1 = 16'd5,
                UART_TX_BIT2 = 16'd6,
                UART_TX_BIT3 = 16'd7,
                UART_TX_BIT4 = 16'd8,
                UART_TX_BIT5 = 16'd9,
                UART_TX_BIT6 = 16'd10,
                UART_TX_BIT7 = 16'd11,
                UART_TX_STOP_BIT = 16'd12;
    reg [4:0]   present_state,next_state;


    reg [15:0]  bps_cnt,bps_cnt_max;
    wire bps_marker;
    reg [7:0] uart_send_bytes;
    parameter START_BIT = 1'b0;
    parameter STOP_BIT = 1'b1;


    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            bps_cnt_max <= 16'd10414;
        end
        else
        begin
            case(Baud_set)
                4'b0000: bps_cnt_max <= 16'd10414;
                4'b0001: bps_cnt_max <= 16'd5208;
                4'b0010: bps_cnt_max <= 16'd2604;
                4'b0011: bps_cnt_max <= 16'd1736;
                4'b0100: bps_cnt_max <= 16'd868;
                default : bps_cnt_max <= 16'd10414;
            endcase
        end

    end

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            bps_cnt <= 16'd0;
        end
        else if(bps_cnt < (bps_cnt_max-1))
        begin
            bps_cnt <= bps_cnt + 1'b1;
        end
        else
        begin
            bps_cnt <= 16'd0;
        end
    end

    assign bps_marker = (bps_cnt == (bps_cnt_max-1));

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            present_state <= FIFO_IS_EMPTY;
        end
        else
        begin
            present_state <= next_state;
        end
    end

    always @(*)
    begin
        case (present_state)
            FIFO_IS_EMPTY:
            begin
                if(empty)
                begin
                    next_state <= FIFO_IS_EMPTY;
                end
                else
                begin
                    next_state <= FIFO_RD_EN;
                end
            end
            FIFO_RD_EN:
            begin
                next_state <= FIFO_READ;
            end
            FIFO_READ:
            begin
                if(bps_marker)
                begin
                    next_state <= UART_TX_START_BIT;
                end
                else
                begin
                    next_state <= FIFO_READ;
                end

            end
            UART_TX_START_BIT:
            begin
                if(bps_marker)
                begin
                    next_state <= UART_TX_BIT0;
                end
                else
                begin
                    next_state <= UART_TX_START_BIT;
                end
            end
            UART_TX_BIT0:
            begin
                if(bps_marker)
                begin
                    next_state <= UART_TX_BIT1;
                end
                else
                begin
                    next_state <= UART_TX_BIT0;
                end
            end
            UART_TX_BIT1:
            begin
                if(bps_marker)
                begin
                    next_state <= UART_TX_BIT2;
                end
                else
                begin
                    next_state <= UART_TX_BIT1;
                end
            end
            UART_TX_BIT2:
            begin
                if(bps_marker)
                begin
                    next_state <= UART_TX_BIT3;
                end
                else
                begin
                    next_state <= UART_TX_BIT2;
                end
            end
            UART_TX_BIT3:
            begin
                if(bps_marker)
                begin
                    next_state <= UART_TX_BIT4;
                end
                else
                begin
                    next_state <= UART_TX_BIT3;
                end
            end
            UART_TX_BIT4:
            begin
                if(bps_marker)
                begin
                    next_state <= UART_TX_BIT5;
                end
                else
                begin
                    next_state <= UART_TX_BIT4;
                end
            end
            UART_TX_BIT5:
            begin
                if(bps_marker)
                begin
                    next_state <= UART_TX_BIT6;
                end
                else
                begin
                    next_state <= UART_TX_BIT5;
                end
            end
            UART_TX_BIT6:
            begin
                if(bps_marker)
                begin
                    next_state <= UART_TX_BIT7;
                end
                else
                begin
                    next_state <= UART_TX_BIT6;
                end
            end
            UART_TX_BIT7:
            begin
                if(bps_marker)
                begin
                    next_state <= UART_TX_STOP_BIT;
                end
                else
                begin
                    next_state <= UART_TX_BIT7;
                end
            end
            UART_TX_STOP_BIT:
            begin
                if(bps_marker)
                begin
                    next_state <= FIFO_IS_EMPTY;
                end
                else
                begin
                    next_state <= UART_TX_STOP_BIT;
                end
            end
            default: next_state <= FIFO_IS_EMPTY;
        endcase
    end


    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            rd_en <= 1'b0;
            uart_tx <= 1'b1;
            uart_send_bytes <= 8'hff;
            led_tx <= 1'b0;
        end
        else 
        begin
            case (present_state)
                    FIFO_IS_EMPTY:
                    begin
                        rd_en <= 1'b0;
                        uart_tx <= 1'b1;
                        led_tx <= 1'b0;
                    end
                    FIFO_RD_EN:
                    begin
                        rd_en <= 1'b1;
                        uart_tx <= 1'b1;
                        led_tx <= 1'b0;
                    end
                    FIFO_READ:
                    begin
                        rd_en <= 1'b0;
                        uart_tx <= 1'b1;
                        uart_send_bytes <= uart_data;
                        led_tx <= 1'b0;
                    end
                    UART_TX_START_BIT:
                    begin
                        rd_en <= 1'b0;
                        uart_tx <= START_BIT;
                        led_tx <= 1'b1;
                    end
                    UART_TX_BIT0:
                    begin
                        rd_en <= 1'b0;
                        uart_tx <= uart_send_bytes[0];
                        led_tx <= 1'b1;
                    end
                    UART_TX_BIT1:
                    begin
                        rd_en <= 1'b0;
                        uart_tx <= uart_send_bytes[1];
                        led_tx <= 1'b1;                        
                    end
                    UART_TX_BIT2:
                    begin
                        rd_en <= 1'b0;
                        uart_tx <= uart_send_bytes[2];
                        led_tx <= 1'b1;                        
                    end
                    UART_TX_BIT3:
                    begin
                        rd_en <= 1'b0;
                        uart_tx <= uart_send_bytes[3];
                        led_tx <= 1'b1;                        
                    end
                    UART_TX_BIT4:
                    begin
                        rd_en <= 1'b0;
                        uart_tx <= uart_send_bytes[4];
                        led_tx <= 1'b1;
                    end
                    UART_TX_BIT5:
                    begin
                        rd_en <= 1'b0;
                        uart_tx <= uart_send_bytes[5];
                        led_tx <= 1'b1;
                    end
                    UART_TX_BIT6:
                    begin
                        rd_en <= 1'b0;
                        uart_tx <= uart_send_bytes[6];
                        led_tx <= 1'b1;                       
                    end
                    UART_TX_BIT7:
                    begin
                        rd_en <= 1'b0;
                        uart_tx <= uart_send_bytes[7];
                        led_tx <= 1'b1;                        
                    end
                    UART_TX_STOP_BIT:
                    begin
                        rd_en <= 1'b0;
                        uart_tx <= STOP_BIT;
                        led_tx <= 1'b1;     
                    end
                    default:
                    begin
                        rd_en <= 1'b0;
                        uart_tx <= 1'b1;
                        led_tx <= 1'b0;
                    end
                endcase
        end
    end

endmodule
