`timescale 1ns / 1ps



module data_gen(
    input clk,
    input rst,
    input full,
    output reg wr_en,
    output reg [7:0] gen_data
    );

    parameter   IDLE = 3'b001,
                FIFO_IS_FULL = 3'b010,
                FIFO_WRITE = 3'b100;
    reg [3:0]   present_state,next_state;


    wire [7:0] STU_NUM [0:7];
    assign STU_NUM[0] = 8'h20;
    assign STU_NUM[1] = 8'h21;
    assign STU_NUM[2] = 8'hEE;
    assign STU_NUM[3] = 8'h80;
    assign STU_NUM[4] = 8'h14;
    assign STU_NUM[5] = 8'h08;
    assign STU_NUM[6] = 8'h20;
    assign STU_NUM[7] = 8'h01;


    reg [31:0] counter;

    parameter COUNTER_100MS = 32'd5_000_000;
    wire marker_100ms;
    reg [2:0] i;

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            counter <= 32'd0;
        end
        else if (counter < (COUNTER_100MS-1))
        begin
            counter <= 32'd0;
        end

    end
    
    assign marker_100ms = (counter == (COUNTER_100MS-1));

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            present_state <= IDLE;
        end
        else 
        begin
            present_state <= next_state;
        end
    end

    always @(*)
    begin
        case (present_state)
            IDLE :
            begin
                if(marker_100ms)
                begin
                    next_state <= FIFO_IS_FULL;
                end
                else
                begin
                    next_state <= IDLE;
                end
            end
            FIFO_IS_FULL:
            begin
                if(full)
                begin
                    next_state <= FIFO_IS_FULL;
                end
                else
                begin
                    next_state = FIFO_WRITE;
                end
            end
            FIFO_WRITE:
            begin
                next_state <= IDLE;
            end
            default:next_state <= IDLE;
        endcase

    end

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            wr_en <= 1'b0;
            gen_data <= 8'h00;
            i <= 3'd0;
        end
        else 
        begin
            case(present_state)
                IDLE:
                begin
                    if(marker_100ms)
                    begin
                        wr_en <= 1'b0;
                        gen_data <= 8'h00;
                    end
                end
                FIFO_IS_FULL:
                begin
                        wr_en <= 1'b0;
                        gen_data <= 8'h00;
                end
                FIFO_WRITE:
                begin
                        wr_en <= 1'b1;
                        gen_data <= STU_NUM[i];
                        i <= i+3'd1;
                end
                default:
                begin
                        wr_en <= 1'b0;
                        gen_data <= 8'h00;
                end
            endcase

        end
    end



endmodule
