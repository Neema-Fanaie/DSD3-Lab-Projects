`timescale 1ns / 1ps

module Multiplexer(
    input [1:0] Control,
    input [4:0] In_0,
    input [4:0] In_1,
    input [4:0] In_2,
    input [4:0] In_3,
    output reg [4:0] Out
    );
    
    always@(Control or In_0 or In_1 or In_2 or In_3) begin
        case(Control)
            2'b00: Out <= In_0;
            2'b01: Out <= In_1;
            2'b10: Out <= In_2;
            2'b11: Out <= In_3;
            default: Out <= 5'b00000;
        endcase
    end 
endmodule
