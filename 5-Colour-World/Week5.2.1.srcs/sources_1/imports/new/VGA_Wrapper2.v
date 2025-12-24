`timescale 1ns / 1ps

module VGA_Wrapper2(
    input Clk,  
    input Reset,  
    input [11:0] Colour_In,
    input [3:0] CNTRL,
    output [11:0] Colour_Out,
    output HS,
    output VS
    );

    wire TriggOut;
    wire [11:0] Colour_Wire1;
    wire [11:0] Colour_Wire2;
    wire [9:0] X;
    wire [8:0] Y;

    Clock_Control CLK_CNTRL(
        .Clk(Clk),
        .Reset(Reset),
        .Trigger(TriggOut)
    );
    
    Frame_gen FrGen(
        .Colour_In(Colour_Wire1),
        .X(X),
        .Y(Y),
        .CNTRL(CNTRL),
        .Clk(TriggOut),
        .Colour_Out(Colour_Wire2)
    );
    
    VGA_Display2 VGA_Control(
        .Clk25(TriggOut),
        .Colour_In(Colour_In),
        .Reset(Reset),
        .AddrH(X),
        .AddrV(Y),
        .Colour_Out(Colour_Wire1),
        .HS(HS),
        .VS(VS) 
    );    
    
    assign Colour_Out = Colour_Wire2;
    
endmodule
