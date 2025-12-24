`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2025 02:56:04 PM
// Design Name: 
// Module Name: Sync_Mach
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Sync_Mach(
    input Clk,
    input Reset,
    input BTNL,
    input BTNC, 
    input BTNR,
    input [2:0] STATE_OUT,
    output [3:0] Seg_Out,
    output [7:0] Hex_Out
    );
    
    reg [2:0] Curr_State;
    reg [2:0] Next_State;
    
    always@(posedge Clk) begin
        if (Reset) Curr_State <= 3'd6;
        else Curr_State <= Next_State;
    end
    
    always@(Curr_State or BTNL or BTNC or BTNR) begin
        case (Curr_State) 
            
            3'd0: begin
                if (BTNC) Next_State <= 3'd2;
                else if (BTNL || BTNR) Next_State <= Curr_State;
            end
            
            3'd6:  begin
                if (BTNR) Next_State <= 3'd6;
                else if (BTNL) Next_State <= 3'd0;
                else if (BTNC) Next_State <= Curr_State;
            end
            
            3'd2:  begin
                if (BTNC) Next_State <= 3'd1;
                else if (BTNL) Next_State <= 3'd0;
                else if (BTNR) Next_State <= Curr_State;
            end
            
            3'd1:  begin
                if (BTNL) Next_State <= 3'd5;
                else if (BTNR) Next_State <= 3'd2;
                else if (BTNC) Next_State <= Curr_State;
            end
            
            3'd5:  begin
                if (BTNC) Next_State <= 3'd3;
                else if (BTNR) Next_State <= 3'd0;
                else if (BTNL) Next_State <= Curr_State;
            end
            
            3'd3:  begin
                if (BTNL) Next_State <= 3'd4;
                else if (BTNR) Next_State <= 3'd2;
                else if (BTNC) Next_State <= Curr_State;
            end

            3'd4:  begin
                if (BTNR) Next_State <= 3'd7;
                else if (BTNC) Next_State <= 3'd6;
                else if (BTNL) Next_State <= Curr_State;
            end            

            3'd7:  begin
                if (BTNC || BTNR || BTNL) Next_State <= Curr_State;
            end
        endcase
    end
    
    wire [3:0] Bin_In = {1'b0, State_Out};

    Seg7Control Seg7 (
        .Seg_Select_In(2'b00),
        .Bin_In(Bin_In),
        .Dot_In(1'b0),
        .Seg_Select_Out(Seg_Out),
        .Hex_Out(Hex_Out)
    );
    
    
    assign State_Out = Curr_State;
    
endmodule
