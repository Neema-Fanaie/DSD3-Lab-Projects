`timescale 1ns / 1ps

module Frame_gen(
    input [11:0] Colour_In,
    input [9:0] X,
    input [8:0] Y,
    input Clk,
    input [3:0] CNTRL,
    output reg [11:0] Colour_Out
);
    
//    parameter X1 = 300;
//    parameter X2 = 340;
//    parameter Y1 = 220;
//    parameter Y2 = 260;
    
//    always@(posedge Clk) begin
//        if (X> X1 && X < X2 
//            && Y > Y1 && Y < Y2) Colour_Out <= ~Colour_In;
//        else Colour_Out <= Colour_In;
//    end
    
//    parameter Min = 20;
//    parameter Max_X = 640 - Min;
//    parameter Max_Y = 480 - Min;
     
//    always@(posedge Clk) begin
//        if(X < Min && Y < Min
//            || X > Max_X && Y < Min
//            || X < Min && Y > Max_Y
//            || X > Max_X && Y > Max_Y) Colour_Out <= ~ Colour_In;
//        else Colour_Out <= Colour_In;   
//    end
    
    reg [9:0] start_x = 0;
    reg [8:0] start_y = 0;
    
    always@(CNTRL) begin
        case(CNTRL)
            4'b0001: start_x = start_x + 1;
            4'b0010: start_x = start_x - 1;
            4'b0100: start_y = start_y + 1;
            4'b1000: start_y = start_y -1;
            default: begin
                start_x = start_x;
                start_y = start_y;
            end
         endcase
         if(X == start_x && Y == start_y) Colour_Out <= ~ Colour_In;
         else Colour_Out <= Colour_In;   
    end
    
endmodule