`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 14:06:21
// Design Name: 
// Module Name: Hello_synchronous_world
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


module Hello_synchronous_world(
    input CLK,
    input IN,
    output reg OUT,     //do not forget reg
    output reg OUTBAR
    );
    
    always@(posedge CLK) begin
        OUT <= IN;
        OUTBAR <= ~ IN;
    end
endmodule
