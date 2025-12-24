`timescale 1ns / 1ps

module Frame_Generator(
    input               Clk,
    input       [9:0]   X,
    input       [8:0]   Y,
    input       [1:0]   MSM_State,
    input       [11:0]  Colour_In,
    output      [11:0]  Colour_Out
    );
    
    // ??? This Feels Wrong NGL    
    assign Colour_Out = Colour_In;
    
endmodule
