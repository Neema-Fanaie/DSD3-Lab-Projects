`timescale 1ns / 1ps

module Top_Wrapper(
//    Q1.
    input CLK,
    input Enable,
    input Reset,
//    Q2.     
    input Increase,
    input Decrease,
//    Q1.    
    output [3:0] Seg_Select,
    output [7:0] Dec_Out,
//    Q2.
    output [3:0] LEDs,
//    Q4.
    output HS,
    output VS,
    output [11:0] Colour_Out
    );
    
    LEDs_speed Q2(
        .Increase(Increase),
        .Decrease(Decrease),
        .CLK(CLK),
        .LEDs(LEDs)
    );

    Q1_Wrapper Q1(
        .CLK(CLK),
        .Enable(Enable),
        .Reset(Reset),
        .Seg_Select(Seg_Select),
        .Dec_Out(Dec_Out)
    );
    
    VGA_Wrapper2 VGA_Control(
        .Clk(CLK),  
        .Reset(Reset),  
        .Colour_Out(Colour_Out),
        .HS(HS),
        .VS(VS)
    );
endmodule
