`timescale 1ns / 1ps

module CPU_TB(
    );
    
    reg             Clk;
    reg             Enable_Switch;
    reg     [3:0]   In;
    wire    [3:0]   Out;
    
    CPU_Wrapper uut (
        .Clk(Clk),
        .Enable_Switch(Enable_Switch),
        .In(In),
        .Out(Out)
    );
    
    initial begin
        Clk = 0;
        forever #10 Clk = ~Clk;
    end
    
    initial begin
        In = 4'b0110;
        #80 Enable_Switch = 1;
    end
endmodule
