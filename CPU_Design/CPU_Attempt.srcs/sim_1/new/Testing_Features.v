`timescale 1ns / 1ps

module Testing_Features(
    );

    reg [7:0] RAM [0:15];
    reg [7:0] Val;
    initial begin
        RAM[0] = 8'b01101110;
        RAM[1] = 8'b10010111;
        Val = 4'b0;
        #20 Val = RAM[1][7:4];
    end  
endmodule
