`timescale 1ns / 1ps

module Seg7Control(
    input [1:0] Seg_Select_In,
    input [3:0] Bin_In,
    input Dot_In,
    output reg [3:0] Seg_Select_Out,
    output reg [7:0] Hex_Out
    );
    
    // segment selection
    always@(Seg_Select_In) begin
        case(Seg_Select_In)
            2'b00 : Seg_Select_Out <= 4'b1110;
            2'b01 : Seg_Select_Out <= 4'b1101;
            2'b10 : Seg_Select_Out <= 4'b1011;
            2'b11 : Seg_Select_Out <= 4'b0111;
            default: Seg_Select_Out <= 4'b1111;
        endcase
    end 
    
    always@(Bin_In or Dot_In) begin
        case(Bin_In)
            4'h0: Hex_Out[6:0] <= 7'b1000000;
            4'h1: Hex_Out[6:0] <= 7'b1111001;
            4'h2: Hex_Out[6:0] <= 7'b0100100;
            4'h3: Hex_Out[6:0] <= 7'b0110000;

            4'h4: Hex_Out[6:0] <= 7'b0011001;
            4'h5: Hex_Out[6:0] <= 7'b0010010;
            4'h6: Hex_Out[6:0] <= 7'b0000010;
            4'h7: Hex_Out[6:0] <= 7'b1111000;

            4'h8: Hex_Out[6:0] <= 7'b0000000;
            4'h9: Hex_Out[6:0] <= 7'b0011000;
            4'hA: Hex_Out[6:0] <= 7'b0001000;
            4'hB: Hex_Out[6:0] <= 7'b1100000;

            4'hC: Hex_Out[6:0] <= 7'b0110001;
            4'hD: Hex_Out[6:0] <= 7'b1000010;
            4'hE: Hex_Out[6:0] <= 7'b0110000;
            4'hF: Hex_Out[6:0] <= 7'b0111000;
            
            default: Hex_Out[6:0] <= 7'b1111111;
        endcase
        Hex_Out[7] <= ~Dot_In;
    end
    
endmodule
