`timescale 1ns / 1ps

module In_OutTB(
    );
    
    reg             Clk;
    reg             Reset;
    reg             BTNU;
    reg             BTNL;
    reg             BTNR;
    reg             BTND;
    wire    [3:0]   Seg_Select;
    wire    [7:0]   Hex_Out;
    wire    [11:0]  Colour_Out;
    wire            HS;
    wire            VS;
    
    Input_Output uut(
        .Clk(Clk),
        .Reset(Reset),
        .BTNU(BTNU),
        .BTND(BTND),
        .BTNR(BTNR),
        .BTNL(BTNL),
        .Seg_Select(Seg_Select),
        .Hex_Out(Hex_Out),
        .Colour_Out(Colour_Out),
        .HS(HS),
        .VS(VS)
    );
    
    initial begin
        Clk = 0;
        forever #10 Clk = ~Clk;
    end
    
    initial begin
        BTNU = 0; BTNL = 0; BTND = 0; BTNR = 0; Reset = 1;
        #15 Reset = 0;
    end
endmodule
