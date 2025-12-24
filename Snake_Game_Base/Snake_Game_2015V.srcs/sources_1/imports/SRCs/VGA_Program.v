`timescale 1ns / 1ps

module VGA_Program(
    input           Clk,
    input   [11:0]  Colour,
    input   [1:0]   MSM_State,
    output  [9:0]   X,
    output  [8:0]   Y,
    output  [11:0]  Colour_Out,
    output          HS,
    output          VS
    );

    // Convert 100MHz clock to 25MHz
    reg [1:0] Clk_Counter = 0;
    wire Clk25;

    always@(posedge Clk) begin
        Clk_Counter <= Clk_Counter + 1;
    end

    assign Clk25 = Clk_Counter[1];

    // Connect frame generator to VGA interface
    wire [11:0] Colour_In;
    wire [9:0] X_Addr;
    wire [8:0] Y_Addr;

    Frame_Generator Fr_Gen(
        .Clk(Clk),
        .MSM_State(MSM_State),
        .X(X_Addr),
        .Y(Y_Addr),
        .Colour_In(Colour),
        .Colour_Out(Colour_In)
       );

    VGA_Interface VGA_CNTRL(
        .Clk(Clk25),
        .Colour_In(Colour_In),
        .AddrH(X_Addr),
        .AddrV(Y_Addr),
        .Colour_Out(Colour_Out),
        .HS(HS),
        .VS(VS)
    );

    assign X = X_Addr;
    assign Y = Y_Addr;
    
endmodule
