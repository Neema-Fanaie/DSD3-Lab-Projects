`timescale 1ns / 1ps

module Counting_the_world(
    input Button,
    input Control_switch,
    input Reset,
    output [15:0] LEDS
    );
    
    reg [15:0] Value = 16'd0;
    
    always@(posedge Button or posedge Reset) begin
        if(Reset) Value = 0;
        else begin 
            if(Control_switch)
                Value <= Value + 1;
            else
                Value <= Value - 1;
        end
    end
    
    assign LEDS = Value;

endmodule
