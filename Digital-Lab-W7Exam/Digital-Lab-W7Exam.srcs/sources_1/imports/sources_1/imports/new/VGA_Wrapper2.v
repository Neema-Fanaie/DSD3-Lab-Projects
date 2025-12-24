`timescale 1ns / 1ps

module VGA_Wrapper2(
    input Clk,  
    input Reset,  
    output [11:0] Colour_Out,
    output HS,
    output VS
    );

    wire TriggOut;
    wire [11:0] Colour_Wire1;
    wire [11:0] Colour_Wire2;
    wire [9:0] X;
    wire [8:0] Y;
    wire [11:0] Colour_In;
    
    // Configure Clock to 25MHz for VGA 
    Clock_Control CLK_CNTRL(
        .Clk(Clk),
        .Reset(Reset),
        .Trigger(TriggOut)
    );
    
    // Call frame gen to control colour of the pixels
    Frame_gen FrGen(
        .X(X),
        .Y(Y),
        .CLK(TriggOut),
        .Colour_Out(Colour_In)
    );
    
    // Call VGA Module 
    VGA_Display2 VGA_Control(
        .CLK(TriggOut),
        .Colour_In(Colour_In),
        .AddrH(X),
        .AddrV(Y),
        .Colour_Out(Colour_Out),
        .HS(HS),
        .VS(VS) 
    );    
    
endmodule
