`timescale 1ns / 1ps

module Seg7_Interface(
    input   [1:0]   Strobe_Counter,
    input   [7:0]   Current_Score,
    output  [3:0]   Seg_Select,
    output  [7:0]   Hex_Out
    );
    
    wire [3:0] Mux_Out;
    
    Multiplexer Mux(
        .Control(Strobe_Counter),
        .In_0(Current_Score[3:0]), 
        .In_1(Current_Score[7:4]),
        .In_2(4'b0),
        .In_3(4'b0),
        .Out(Mux_Out)
    );
    
    Seg7Control Seg7(
        .Seg_Select_In(Strobe_Counter),
        .Bin_In(Mux_Out),
        .Dot_In(1'b0),
        .Seg_Select_Out(Seg_Select),
        .Hex_Out(Hex_Out)
    );
    
endmodule
