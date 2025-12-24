`timescale 1ns / 1ps

module Seg7_Wrapper(
    input           Clk,
    input           Reset,
    input   [7:0]   Current_Score,
    input   [7:0]   Current_Time,
    input   [1:0]   Play_State,
    output  [3:0]   Seg_Select,
    output  [7:0]   Hex_Out
    );

// ----- Generic Counter Module used to Generate Strobe_Counter ----- //
    wire Bit17TriggOut;
    wire [1:0] Strobe_Counter; 
    Generic_Counter #(.Counter_Width(17),
                      .Counter_Max(99999)
                      ) 
                      Bit17Counter (
                      .Clk(Clk),
                      .Reset(1'b0),
                      .Enable(1'b1),
                      .Trig_Out(Bit17TriggOut)
                     );
                     
    Generic_Counter #(.Counter_Width(2),
                      .Counter_Max(3)
                     ) StrobeCounter(
                      .Clk(Clk),
                      .Reset(Reset),
                      .Enable(Bit17TriggOut),
                      .Count(Strobe_Counter)
                     );
                     
    wire [3:0] Mux_Out;
    
// ----- Multiplexer to Control which 7-Segment Display is Being Assigned ----- //
    Multiplexer Mux(
        .Control(Strobe_Counter),
        .In_0(Current_Score[3:0]), 
        .In_1(Current_Score[7:4]),
        .In_2(Current_Time[3:0]),
        .In_3(Current_Time[7:4]),
        .Out(Mux_Out)
    );
        
// ----- 7-Segment Display Control ----- //
    Seg7Control Seg7(
        .Seg_Select_In(Strobe_Counter),
        .Bin_In(Mux_Out),
        .Dot_In(1'b0),
        .Seg_Select_Out(Seg_Select),
        .Hex_Out(Hex_Out)
    );
    
endmodule
