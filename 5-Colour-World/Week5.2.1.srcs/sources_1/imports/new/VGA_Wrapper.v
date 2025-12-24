`timescale 1ns / 1ps

module VGA_Wrapper(
    input Clk,  
    input Reset,  
    input [11:0] Colour_In,
    output [11:0] Colour_Out,
    output HS,
    output VS
    );
    
    wire Video_On;
    reg [11:0] Colour_Control;

    
    wire TriggOut;
    Clock_Control CLK_CNTRL(
        .Clk(Clk),
        .Reset(Reset),
        .Trigger(TriggOut)
    );
    
    wire [9:0] AddrH, AddrV;
    
    always@(posedge Clk or posedge Reset) begin
        if(Reset) Colour_Control <= 0;
        else if(AddrH <= 10 && AddrV <= 10) Colour_Control <= ~Colour_In;
        else Colour_Control <= ~Colour_In;
    end
    
    VGA_Display VGA (
        .Clk(Clk),
        .Clk_25(TriggOut),
        .AddrH(AddrH),
        .AddrV(AddrV),
        .HS(HS),
        .VS(VS),
        .Video_On(Video_On)
    );
    
//    always@(posedge Clk or posedge Reset) begin
//        if(Reset) Colour_Control <= 0;
//        else Colour_Control <= Colour_In;
//    end
    
    assign Colour_Out = (Video_On) ? Colour_Control: 12'b0;
    
endmodule
