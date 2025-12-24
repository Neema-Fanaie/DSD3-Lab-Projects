`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 14:42:18
// Design Name: 
// Module Name: Hello_Syn_World
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


module Hello_Syn_World(
    );
    
    reg CLK;
    reg IN;
    
    wire OUT;
    
    Hello_synchronous_world uut (
        .CLK(CLK),
        .IN(IN),
        .OUT(OUT)
    );
    
initial begin
    CLK = 0;
    forever #100 CLK =~ CLK;
end 
    
initial begin
    IN = 0;
    #100
    #50 IN = 1;
    #50 IN = 0;
    #200 IN = 1;
    #200 IN = 1;
    #20 IN = ~IN;
    #20 IN = ~IN;
    #20 IN = ~IN;
    #20 IN = ~IN;
    #20 IN = ~IN;
    #20 IN = ~IN;
    #20 IN = ~IN;
    #20 IN = ~IN;
    #20 IN = ~IN;
    #20 IN = ~IN;
end
endmodule
