`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2025 14:55:06
// Design Name: 
// Module Name: VGA_Sim
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


module VGA_Sim(
    );
    reg Clk;
    reg Reset;
    reg [11:0] Colour_In = 12'd0;
    wire [9:0] AddrH;
    wire [8:0] AddrV;
    wire [11:0] Colour_Out;
    //reg HS = 0;
    //reg VS = 0;
    
    wire HS_wire;
    wire VS_wire;
    
    VGA_Display2 uut(
        .Clk25(Clk),
        .Colour_In(Colour_In),
        .Reset(Reset),
        .AddrH(AddrH),
        .AddrV(AddrV),
        .Colour_Out(Colour_Out),
        .HS(HS_wire),
        .VS(VS_wire) 
    );
    
    initial begin
        Clk = 0;
        forever #5 Clk = ~ Clk;
    end
    
    initial begin
        #10 Reset = 1;
        #10 Reset = 0;
    end
//    assign HS = HS_wire;
//    assign VS = VS_wire;

endmodule
