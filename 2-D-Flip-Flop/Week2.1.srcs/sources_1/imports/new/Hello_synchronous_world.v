`timescale 1ns / 1ps

module Hello_synchronous_world(
    input CLK,
    input IN,
    output reg OUT,     //do not forget reg
    output reg OUTBAR
    );
    
    always@(posedge CLK) begin
        OUT <= IN;
        OUTBAR <= ~ IN;
    end
    
endmodule