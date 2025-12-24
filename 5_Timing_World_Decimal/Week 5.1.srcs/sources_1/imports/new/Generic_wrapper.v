`timescale 1ns / 1ps

module Generic_wrapper(
    input Clk,
    input Reset,
    input Enable,
    //OUTPUTS
    output [3:0] Seg_Select,
    output [7:0] Dec_Out,
    output LED
    );
    
    wire Bit17TriggOut;
    Generic_counter #(.Counter_Width(17),
                      .Counter_Max(99999)
                      ) 
                      Bit17Counter (
                      .Clk(Clk),
                      .Reset(1'b0),
                      .Enable(1'b1),
                      .Trig_Out(Bit17TriggOut)
                     );
                     
    wire [1:0] StrobeCount;
    Generic_counter #(.Counter_Width(2),
                      .Counter_Max(3)
                     ) StrobeCounter(
                      .Clk(Clk),
                      .Reset(Reset),
                      .Enable(Bit17TriggOut),
                      .Count(StrobeCount)
                     );
    
    wire Enable_Gate = Enable & Bit17TriggOut;           
    

    wire DecTrigPre;
    Generic_counter #(  .Counter_Width(4), 
                        .Counter_Max(9)
                      ) PreDecCounter (
                        .Clk(Clk),
                        .Reset(Reset),
                        .Enable(Enable_Gate), 
                        .Trig_Out(DecTrigPre)
                    );
    
    wire [3:0] DecCount0, DecCount1, DecCount2, DecCount3;     
    wire DecTrig0, DecTrig1, DecTrig2;
    Generic_counter #(  .Counter_Width(4),
                        .Counter_Max(9)
                      ) DecCounter0 (
                        .Clk(Clk),
                        .Reset(Reset),
                        .Enable(DecTrigPre),
                        .Trig_Out(DecTrig0),
                        .Count(DecCount0)
                     );
    Generic_counter #(  .Counter_Width(4),
                        .Counter_Max(9)
                      ) DecCounter1 (
                        .Clk(Clk),
                        .Reset(Reset),
                        .Enable(DecTrig0),
                        .Trig_Out(DecTrig1),
                        .Count(DecCount1)
                     );
    Generic_counter #(  .Counter_Width(4), .Counter_Max(9)) 
                        DecCounter2 (
                        .Clk(Clk),
                        .Reset(Reset),
                        .Enable(DecTrig1),
                        .Trig_Out(DecTrig2),
                        .Count(DecCount2)
                     );   
    Generic_counter #(  .Counter_Width(4),
                        .Counter_Max(9)
                      ) DecCounter3 (
                        .Clk(Clk),
                        .Reset(Reset),
                        .Enable(DecTrig2),
                        .Count(DecCount3)
                     );
        
    wire [4:0] DecCountAndDOT0 = {1'b0, DecCount0};
    wire [4:0] DecCountAndDOT1 = {1'b0, DecCount1};
    wire [4:0] DecCountAndDOT2 = {1'b1, DecCount2};
    wire [4:0] DecCountAndDOT3 = {1'b0, DecCount3};

    wire [4:0] Mux_Out;
    Multiplexer Mux4 (
        .Control(StrobeCount),
        .In_0(DecCountAndDOT0),
        .In_1(DecCountAndDOT1),
        .In_2(DecCountAndDOT2),
        .In_3(DecCountAndDOT3),
        .Out(Mux_Out)
    );

    Seg7Control Seg7(
        .Seg_Select_In(StrobeCount),
        .Bin_In(Mux_Out[3:0]),
        .Dot_In(Mux_Out[4]),
        .Seg_Select_Out(Seg_Select),
        .Hex_Out(Dec_Out)
    );
    
    assign LED = Enable;
endmodule
