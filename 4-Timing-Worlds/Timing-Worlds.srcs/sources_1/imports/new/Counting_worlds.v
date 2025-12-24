`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.09.2025 16:42:01
// Design Name: 
// Module Name: Counting_worlds
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


module Counting_worlds(
    input CLK,
    input Count_Enable,
    input Reset,
    input Count_Control,
    output [7:0] LEDs
    );
    
    reg [7:0] Value;
    reg [26:0] PerSecondCLK;
    
    always@(posedge CLK) begin
        if (Reset) PerSecondCLK = 0;
        else if (Count_Enable) begin
            if(Count_Control) begin
                if(PerSecondCLK == 100_000_000) PerSecondCLK <= 0;
                else PerSecondCLK <= PerSecondCLK + 1;
            end 
            else begin
                if(PerSecondCLK == 0) PerSecondCLK <= 100_000_000;
                else PerSecondCLK <= PerSecondCLK - 1;
            end 
        end
    end 
    
    always@(posedge CLK) begin
        if(Reset) 
            Value <= 0;
        else begin
            if((PerSecondCLK == 100_000_000) & Count_Control)
                Value = Value - 1; 
            else if (PerSecondCLK == 100_000_000)
                Value = Value + 1; 
        end
    end
    assign LEDs = Value;
endmodule
