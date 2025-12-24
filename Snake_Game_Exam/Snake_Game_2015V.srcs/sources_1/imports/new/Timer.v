`timescale 1ns / 1ps

module Timer(
    input           Clk,
    input           Reset,
    input   [1:0]   MSM_State,
    output  [7:0]   Current_Time
    );
    
//  Wires for module connections
    wire Base_Trig_Out, Ones_Trig_Out;
    wire [3:0] Ones_Count;
    wire [3:0] Tens_Count;
    wire Enable = Base_Trig_Out && (MSM_State == 2'b01);
    
//  Current Time Register
    reg [7:0] Curr_Time;
    reg Clock_Reset;

//  sets 1 Sec Clock Speed
    Generic_Counter #(  .Counter_Width(27),
                        .Counter_Max(99999999)
                     )Clock_Base(
                        .Clk(Clk),
                        .Reset(Reset),
                        .Enable(1'b1),
                        .Trig_Out(Base_Trig_Out)
                     );
    
//  Countdown from 9
    Generic_Countdown #(  .Counter_Width(4),
                        .Counter_Max(9),
                        .Start_Value(9)
                    )Ones_Coloumn(
                        .Clk(Clk),
                        .Reset(Clock_Reset),
                        .Enable(Enable),
                        .Trig_Out(Ones_Trig_Out),
                        .Count(Ones_Count)
                    );
    
//    Countdown from 2
    Generic_Countdown #(  .Counter_Width(4),
                        .Counter_Max(9),
                        .Start_Value(2)
                    )Tens_Coloumn(
                        .Clk(Clk),
                        .Reset(Clock_Reset),
                        .Enable(Ones_Trig_Out),
                        .Count(Tens_Count)
                    );

//  Logic to Allow Game to be Replayed once "Lost"            
    always@(posedge Clk) begin
        if(Reset || MSM_State == 2'b00) begin
            Curr_Time <= 8'h29;
            Clock_Reset <= 1;
        end
        else begin
            Curr_Time <= {Tens_Count, Ones_Count};
            Clock_Reset <= 0;
        end
    end
    
    
    assign Current_Time = Curr_Time;
    
endmodule
