`timescale 1ns / 1ps

module VGA_Program(
    input           Clk,
    input   [11:0]  Colour,
    output  [9:0]   X,
    output  [8:0]   Y,
    output  [11:0]  Colour_Out,
    output          HS,
    output          VS
    );

    // Convert 100MHz clock to 25MHz
    reg [1:0]   Clk_Counter = 0;
    wire        Clk25;

    always@(posedge Clk) begin
        Clk_Counter <= Clk_Counter + 1;
    end

    assign Clk25 = Clk_Counter[1];

    // Connect Frame Generator to VGA Interface
    wire [11:0] Colour_In;

    Frame_Generator Fr_Gen(
        .Colour_In(Colour),
        .Colour_Out(Colour_In)
       );

    VGA_Interface VGA_CNTRL(
        .Clk(Clk25),
        .Colour_In(Colour_In),
        .AddrH(X),
        .AddrV(Y),
        .Colour_Out(Colour_Out),
        .HS(HS),
        .VS(VS)
    );
    
endmodule
