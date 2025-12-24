`timescale 1ns / 1ps

module Timer(
    input Clk,
    input Reset,
    input [1:0] MSM_State,
    output [7:0] Current_Time
    );
    
    wire Base_Trig_Out, Ones_Trig_Out;
    wire [3:0] Ones_Count;
    wire [3:0] Tens_Count;
    wire Enable = Base_Trig_Out && (MSM_State == 2'b01);
    
    Generic_Counter #(  .Counter_Width(27),
                        .Counter_Max(99999999)
                     )Clock_Base(
                        .Clk(Clk),
                        .Reset(Reset),
                        .Enable(1'b1),
                        .Trig_Out(Base_Trig_Out)
                     );
    
    Generic_Counter #(  .Counter_Width(4),
                        .Counter_Max(9)
                    )Ones_Coloumn(
                        .Clk(Clk),
                        .Reset(Reset),
                        .Enable(Enable),
                        .Trig_Out(Ones_Trig_Out),
                        .Count(Ones_Count)
                    );
    
    Generic_Counter #(  .Counter_Width(4),
                        .Counter_Max(9)
                    )Tens_Coloumn(
                        .Clk(Clk),
                        .Reset(Reset),
                        .Enable(Ones_Trig_Out),
                        .Count(Tens_Count)
                    );
    
    assign Current_Time = {Tens_Count, Ones_Count};
    
endmodule
