`timescale 1ns / 1ps

module Score_CounterTB(
    );
    
    reg             Clk;
    reg             Reset;
    reg             Reached_Target;
    wire    [1:0]   Strobe_Counter;
    wire    [7:0]   Current_Score;
    
    Score_Counter uut1(
        .Clk(Clk),
        .Reset(Reset),
        .Reached_Target(Reached_Target),
        .Strobe_Counter(Strobe_Counter),
        .Current_Score(Current_Score)
    );
    
    wire    [3:0]   Seg_Select;
    wire    [7:0]   Hex_Out;
    
    Seg7_Interface uut2(
        .Strobe_Counter(Strobe_Counter),
        .Current_Score(Current_Score),
        .Seg_Select(Seg_Select),
        .Hex_Out(Hex_Out)
    );
    
    initial begin
        Clk = 0;
        forever #10 Clk = ~Clk;
    end
    
    initial begin
        Reached_Target = 0; Reset = 1; 
        #20 Reset = 0;
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 1
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 2
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 3
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 4
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 5
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 6
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 7
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 8
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 9
        
        Reset = 1; #20 Reset = 0;
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 1
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 2
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 3
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 4
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 5
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 6
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 7
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 8
        #10 Reached_Target = 1; #20 Reached_Target = 0; // 9
        #15 Reached_Target = 1; #30 Reached_Target = 0; // 10
        #15 Reached_Target = 1; #30 Reached_Target = 0; // 10


    end
endmodule
