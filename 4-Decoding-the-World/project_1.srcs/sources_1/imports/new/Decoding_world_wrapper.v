`timescale 1ns / 1ps

module Decoding_world_wrapper(
    input [3:0] Controls,
    input [1:0] Seg_In,
    input DOT,
    output [11:0] Display,
    output [6:0] LEDs
    );

    Seg7Control D(
        .Seg_Select_In(Seg_In),
        .Bin_In(Controls),
        .Dot_In(DOT),
        .Seg_Select_Out(Display[3:0]),
        .Hex_Out(Display[11:4])    
    );
    
    assign LEDs[3:0] = Controls;
    assign LEDs[4] = DOT;
    assign LEDs[6:5] = Seg_In;


endmodule
