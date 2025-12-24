`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.09.2025 11:49:51
// Design Name: 
// Module Name: Shift_register
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


module Shift_register(
    input CLK,
    input IN,
    output [15:0] OUT
    );
    
    wire [16:0] W;
    
    genvar DtypeNo;
    
    generate 
        for (DtypeNo = 0; DtypeNo < 16; DtypeNo = DtypeNo + 1) 
        begin: DtypeInstantiation
            Hello_synchronous_world D (.CLK(CLK), .IN(W[DtypeNo]), .OUT(W[DtypeNo + 1]));
        end 
    endgenerate
    
    assign OUT = W[16:1];
    assign W[0] = IN;
    
endmodule
