`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2025 16:31:17
// Design Name: 
// Module Name: Q1_Wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Q1_Wrapper(
    input CLK,
    input Enable,
    input Reset,
    output [3:0] Seg_Select,
    output [7:0] Dec_Out
    );
    
//  Create register which counts up 
    reg [3:0] Value = 0;
    
//    Create a Modulated Clock Signal
    wire CLK_Sig;
    
    parameter MAX = 4'd15;
    
//    Use of Generic Counter to create 0.5Hz Signal
    Generic_counter # (.Counter_Width(26),
                       .Counter_Max(50000000) 
                       ) Clk_Counter (
                       .Clk(CLK),
                       .Reset(1'b0),
                       .Enable(1'b1),
                       .Trig_Out(CLK_Sig)
                       );
                       
    always@(posedge CLK_Sig or posedge Reset) begin
        if(Reset) Value <= 0;
        else begin
            if(Value == MAX) Value <= 0;
            else if(Enable) Value <= Value + 1;
        end
    end
    
    Seg7Control Seg7(
        .Seg_Select_In(2'b11),
        .Bin_In(Value),
        .Dot_In(1'b0),
        .Seg_Select_Out(Seg_Select),
        .Hex_Out(Dec_Out)
        );
    
endmodule
