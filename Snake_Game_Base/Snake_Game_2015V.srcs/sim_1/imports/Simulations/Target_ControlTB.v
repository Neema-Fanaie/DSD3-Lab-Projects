`timescale 1ns / 1ps


module Target_ControlTB(
    );
    
    reg Clk;
    reg Reset;
    reg Reached_Target;
    wire [7:0] Target_X;
    wire [6:0] Target_Y;
    
    Target_Generator uut(
        .Clk(Clk),
        .Reset(Reset),
        .Reached_Target(Reached_Target),
        .Target_X(Target_X),
        .Target_Y(Target_Y)
    );
    
    initial begin
        Clk = 0;
        forever #10 Clk = ~Clk;
    end
    
    initial begin
        Reset = 1; Reached_Target = 0;
        #15 Reset = 0;
        #80 Reached_Target = 1;
        #20 Reached_Target = 0;
    end
    
endmodule
