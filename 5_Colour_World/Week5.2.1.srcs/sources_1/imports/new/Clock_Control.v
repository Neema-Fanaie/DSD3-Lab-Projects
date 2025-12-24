`timescale 1ns / 1ps

module Clock_Control (
    input Clk,
    input Reset,
    output Trigger
);

    reg [1:0] r_25MHz;
    
    always@(posedge Clk or posedge Reset) begin
        if(Reset) r_25MHz <= 0;
        else r_25MHz <= r_25MHz +1;
    end
    
    assign Trigger = (r_25MHz == 0) ? 1 : 0; 
endmodule

