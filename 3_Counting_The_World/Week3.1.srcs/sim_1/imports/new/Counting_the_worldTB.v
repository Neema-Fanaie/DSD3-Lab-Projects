`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2025 16:30:00
// Design Name: 
// Module Name: Counting_the_worldTB
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


    module Counting_the_worldTB(
    );
    reg Control_switch;
    reg Button;
    
    wire [15:0] LEDS;
    
    Counting_the_world uut(
        .Control_switch(Control_switch),
        .Button(Button),
        .LEDS(LEDS)
    );
    
    initial begin
        Control_switch = 0;
        forever #5 Control_switch = ~Control_switch;
    end
    
    initial begin
        Button = 0;
        #20 Button = 1;
    end
    
endmodule
