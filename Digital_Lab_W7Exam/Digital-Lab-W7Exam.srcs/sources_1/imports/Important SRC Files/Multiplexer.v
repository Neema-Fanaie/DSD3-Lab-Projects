`timescale 1ns / 1ps

module Multiplexer(
    input [1:0] Control,
    output reg [4:0] Out
    );
    
    always@(Control) begin
        case(Control)
            2'b00: Out <= 4'b0001;
            2'b01: Out <= 4'b0010;
            2'b10: Out <= 4'b0100;
            2'b11: Out <= 4'b1000;
            default: Out <= 4'b0000;
        endcase
    end 
endmodule
