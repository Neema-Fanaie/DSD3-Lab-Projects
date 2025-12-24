`timescale 1ns / 1ps

module LEDsTB(
    );
    
    // Initialise all registers and wires for module
    reg CLK;
    reg Increase = 0;
    reg Decrease = 0;
    wire [3:0] LEDs;
    
    LEDs_speed uut (
        .Increase(Increase),
        .Decrease(Decrease),
        .CLK(CLK),
        .LEDs(LEDs)
    );
    
    // Create a Clock Signal 
    initial begin
        CLK = 0;
        forever #20 CLK = ~CLK;
    end
    
    // Set increase to 1 for 1 Clock Cycle
    initial begin
        # 1000000 Increase = 1;
        # 30 Increase = 0;
    end
endmodule
