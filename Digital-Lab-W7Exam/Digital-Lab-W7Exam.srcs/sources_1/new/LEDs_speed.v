`timescale 1ns / 1ps

module LEDs_speed(
    input Increase,
    input Decrease,
    input CLK,
    output [3:0] LEDs
    );
    
//    Parameters to define max speed, Min speed
    parameter Speed_Max = 2'd4;
    parameter Speed_Min = 1'd0;

//    Registers for Speed and Value, and Clock_Signal
    reg [2:0] Speed = 3'd2; 
    reg [1:0] Value = 2'd0;
    reg Clk_Sig;
    
//    Wires to communicate between modules
    wire Clk_Wire1, Clk_Wire2, Clk_Wire3, Clk_Wire4, Clk_Wire5;
//  100Mhz -> 0.25Hz
    Generic_counter # (.Counter_Width(26),
                       .Counter_Max(250000000) 
                       ) Clk_Counter1 (
                        .Clk(CLK),
                        .Reset(1'b0),
                        .Enable(1'b1),
                        .Trig_Out(Clk_Wire1)
                       );  
//     0.25Hz -> 0.5Hz  
     Generic_counter # (.Counter_Width(2),
                        .Counter_Max(1) 
                      ) Clk_Counter2 (
                       .Clk(CLK),
                       .Reset(1'b0),
                       .Enable(Clk_Wire1),
                       .Trig_Out(Clk_Wire2)
                      );   
//  0.5Hz-> 1Hz    
     Generic_counter # (.Counter_Width(2),
                       .Counter_Max(1) 
                       ) Clk_Counter3 (
                        .Clk(CLK),
                        .Reset(1'b0),
                        .Enable(Clk_Wire2),
                        .Trig_Out(Clk_Wire3)
                       );   
//     1Hz -> 2Hz  
    Generic_counter # (.Counter_Width(2),
                     .Counter_Max(1) 
                     ) Clk_Counter4 (
                      .Clk(CLK),
                      .Reset(1'b0),
                      .Enable(Clk_Wire3),
                      .Trig_Out(Clk_Wire4)
                     );   
//  2Hz -> 4Hz   
    Generic_counter # (.Counter_Width(2),
                      .Counter_Max(1) 
                      ) Clk_Counter5 (
                       .Clk(CLK),
                       .Reset(1'b0),
                       .Enable(Clk_Wire4),
                       .Trig_Out(Clk_Wire5)
                      );            
    
    always@(Increase || Decrease) begin
        if(Increase && Speed < Speed_Max) 
            Speed = Speed + 1;
        else Speed <= Speed;
        
        if (Decrease && Speed > Speed_Min) 
            Speed <= Speed - 1;
        else Speed <= Speed;
    end
    
    // Case switch which determines which clock signals to use based on current speed
    always@(posedge CLK) begin
        case(Speed)
            3'b100: Clk_Sig = Clk_Wire5; 
            3'b011: Clk_Sig = Clk_Wire4; 
            3'b010: Clk_Sig = Clk_Wire3; 
            3'b001: Clk_Sig = Clk_Wire2; 
            3'b000: Clk_Sig = Clk_Wire1; 
            default: Clk_Sig = Clk_Wire3;
        endcase
     end
     
//    Define a max value to use in multiplexer
    parameter Value_Max = 3'd4;
    
    always@(posedge Clk_Sig) begin
        if(Value == Value_Max) Value <= 2'b0;
        else Value <= Value + 1;
    end

//    Use Multiplexer to control which light is on based on value    
    Multiplexer Mux(
     .Control(Value),
     .Out(LEDs)
    );

    // Running out of time, but if I were to reattempt, I'd use the D-Flip-Flops from week 2 and have the speed that they move through each other controlled by Clock Signal
endmodule
