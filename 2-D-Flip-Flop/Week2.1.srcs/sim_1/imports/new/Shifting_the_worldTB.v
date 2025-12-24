`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.09.2025 12:02:39
// Design Name: 
// Module Name: Shifting_the_worldTB
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


module Shifting_the_worldTB(
);
    reg CLK;
    reg IN;
    
    wire [15:0] OUT;

    Shift_register uut (
        .CLK(CLK),
        .IN(IN),
        .OUT(OUT)
        );

initial begin
    CLK = 0;
    forever #5 CLK =~ CLK;
end

initial begin
    IN = 0;
    #100 IN = 1;
end

endmodule
