`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.09.2025 14:55:17
// Design Name: 
// Module Name: Helloworld_TB
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
module Helloworld_TB (
);
    // inputs
    reg IN;
    // outputs
    wire OUT;
    
    // instantsiate the unit under test
    Hello_World uut(
        .IN(IN),
        .OUT(OUT)
    );
    
    //Activates our test bench
    initial begin
        //vait 100 ns for global reset to finish
        #100;
        // initiate inputs
        IN = 0;
        // something Intresting
        #500 IN = 1;
    end   
endmodule
