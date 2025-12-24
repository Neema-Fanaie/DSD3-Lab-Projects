`timescale 1ns / 1ps

module Score_Counter(
    input           Clk,
    input           Reset,
    input           Reached_Target,
    output  [7:0]   Current_Score
    );
    
    reg [7:0] Curr_Count;
    reg [7:0] Next_Count;

//  Current-State Logic
    always@(posedge Clk) begin
        if(Reset) Curr_Count <= 8'h00;
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

//  Output for Rest of Program
    assign Current_Score = Curr_Count;    

endmodule
