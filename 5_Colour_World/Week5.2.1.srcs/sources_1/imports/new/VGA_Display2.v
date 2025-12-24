`timescale 1ns / 1ps

module VGA_Display2(
    input Clk25,
    input [11:0] Colour_In,
    input Reset,
    output reg [9:0] AddrH,
    output reg [8:0] AddrV,
    output reg [11:0] Colour_Out,
    output reg HS = 0,
    output reg VS = 0 
    );
    
    // Verticle Lines
    parameter Verticle_PulseWidth = 10'd2;
    parameter Verticle_BackPorch = 10'd31;
    parameter Verticle_DisplayTime = 10'd511;
    parameter Verticle_FrontPorch = 10'd521;
    
    // Horizontal Lines
    parameter Horizontal_PulseWidth = 10'd96;
    parameter Horizontal_BackPorch = 10'd144;
    parameter Horizontal_DisplayTime = 10'd784;
    parameter Horizontal_FrontPorch = 10'd800;
    
    parameter V_Max = 10'd521;
    parameter H_Max = 10'd800;
    reg [9:0] H;
    reg [9:0] V;
    
    always@(posedge Clk25 or posedge Reset) begin
        if(Reset) begin
            H = 0;
            V = 0;
        end else begin
            if(H > H_Max) begin
                H <= 0; 
                V <= V + 1;
                end
            else H <= H + 1;
            if(V > V_Max) V <= 0;
        end
    end
    
    always@(posedge Clk25) begin
        HS <= (H >= Horizontal_PulseWidth) ? 1 : 0;
        VS <= (V >= Verticle_PulseWidth) ? 1: 0;
    end
    
    always@(posedge Clk25) begin
        Colour_Out <=  (V >= Verticle_BackPorch && V <= Verticle_DisplayTime &&
                       H >= Horizontal_BackPorch && H <= Horizontal_DisplayTime)
                       ? Colour_In : 12'b0;
    end
    
    always@(posedge Clk25) begin
        if (V >= Verticle_BackPorch && V <= Verticle_DisplayTime) begin
            AddrV <= V - Verticle_BackPorch + 1;
        end else begin
            AddrV <= 0;
        end
    end
     
    always@(posedge Clk25) begin
        if (H >= Horizontal_BackPorch && H <= Horizontal_DisplayTime)begin
            AddrH <= H - Horizontal_BackPorch + 2;
        end else begin
            AddrH <= 0;
        end
    end
endmodule
