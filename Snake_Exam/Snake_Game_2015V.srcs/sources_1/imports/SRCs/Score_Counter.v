`timescale 1ns / 1ps

module Score_Counter(
    input           Clk,
    input           Reset,
    input           Reached_Target,
    input   [1:0]   MSM_State,
    output  [7:0]   Current_Score,
    output  [3:0]   Seg_Select,
    output  [7:0]   Hex_Out
    );
// TODO: Rewrite to not have a SM implementation, uncesessary for this use 
    
    reg [7:0] Curr_Count;
    reg [7:0] Next_Count;

//  Current-State Logic
    always@(posedge Clk) begin
        if(Reset || MSM_State == 2'b00) Curr_Count <= 8'h00;
        else Curr_Count <= Next_Count;
    end

//  Next-State Logic
    always@(posedge Clk) begin
        if (Reset) Next_Count <= 8'h00;
        else begin 
            case(Curr_Count)
                8'h09: begin
                    if (Reached_Target) Next_Count <= 8'h10;
                    else Next_Count <= Curr_Count;
                end
                default: begin
                    if (Reached_Target) Next_Count <= Curr_Count + 1;
                    else Next_Count <= Curr_Count;                
                end
            endcase 
        end
    end

// ----- Generic Counter Module used to Generate Strobe_Counter ----- //
//  Generate Strobe Counter
    wire Bit17TriggOut;
    Generic_Counter #(.Counter_Width(17),
                      .Counter_Max(99999)
                      ) 
                      Bit17Counter (
                      .Clk(Clk),
                      .Reset(1'b0),
                      .Enable(1'b1),
                      .Trig_Out(Bit17TriggOut)
                     );
                     
    wire [1:0] Strobe_Counter; 
    Generic_Counter #(.Counter_Width(1),
                      .Counter_Max(2)
                     ) StrobeCounter(
                      .Clk(Clk),
                      .Reset(Reset),
                      .Enable(Bit17TriggOut),
                      .Count(Strobe_Counter)
                     );
                     
    wire [3:0] Mux_Out;
    
// ----- Multiplexer to Control which 7-Segment Display is Being Assigned ----- //
    Multiplexer Mux(
        .Control(Strobe_Counter),
        .In_0(Curr_Count[3:0]), 
        .In_1(Curr_Count[7:4]),
        .In_2(4'b0),
        .In_3(4'b0),
        .Out(Mux_Out)
    );
// ----- 7-Segment Display Control ----- //
    Seg7Control Seg7(
        .Seg_Select_In(Strobe_Counter),
        .Bin_In(Mux_Out),
        .Dot_In(1'b0),
        .Seg_Select_Out(Seg_Select),
        .Hex_Out(Hex_Out)
    );

//  Output for Rest of Program
    assign Current_Score = Curr_Count;    

endmodule
