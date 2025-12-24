`timescale 1ns / 1ps

module Frame_gen(
    input CLK,
    input [9:0] X,
    input [8:0] Y,
    output reg [11:0] Colour_Out
);
//    Trigger Wire
    wire Clock_Out;
//    X Coordinate of Screen
    reg [9:0] Curent_X = 9'd80;
//    Parameters to Control Locations
    parameter [9:0] MAX_X = 10'd560;
    parameter [6:0] Width = 7'd80;
    
//    Define Colours for background and shaoe
    parameter [11:0] Background = 12'b111111111111;
    parameter [11:0] Shape = 12'hFF0;
    
//    Use of Generic Counter to Create roughly 5 Sec signal wipe
    Generic_counter # (.Counter_Width(17),
                      .Counter_Max(100000) 
                      ) SecClock (
                       .Clk(CLK),
                       .Reset(1'b0),
                       .Enable(1'b1),
                       .Trig_Out(Clock_Out)
                      );

//    Move X along Screen                          
    always@(posedge Clock_Out) begin
        if(Curent_X >= MAX_X) Curent_X = 9'd80;
        else Curent_X = Curent_X + 1;
    end
    
//    Control Output Colour
    always@(posedge CLK) begin
        if (X >= Curent_X && X <= (Curent_X + Width)) Colour_Out = Shape;
        else Colour_Out = Background;
    end
    
endmodule