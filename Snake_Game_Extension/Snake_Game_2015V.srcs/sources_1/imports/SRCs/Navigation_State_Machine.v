`timescale 1ns / 1ps

module Navigation_State_Machine(
    input           Clk,
    input           Reset,
    input           BTNU,
    input           BTNL,
    input           BTNR,
    input           BTND,
    output  [1:0]   Nav_State
    );

    reg [1:0] Curr_State; 
    reg [1:0] Next_State;
    
//    Current State Logic
    always@(posedge Clk) begin
        if(Reset) Curr_State <= 2'b00;
        else Curr_State <= Next_State;
    end
    
//    Next State Logic
    always@(Curr_State or BTNU or BTNL or BTND or BTNR) begin
        case(Curr_State)
//          Right
            2'b00: begin
                if(BTND) Next_State <= 2'b11;
                else if(BTNU) Next_State <= 2'b01;
                else Next_State <= Curr_State;
            end
          
//          Down
            2'b01: begin
                if(BTNR) Next_State <= 2'b00;
                else if(BTNL) Next_State <= 2'b10;
                else Next_State <= Curr_State;
            end
          
//          Left
            2'b10: begin
                if(BTNU) Next_State <= 2'b01;
                else if(BTND) Next_State <=2'b11;
                else Next_State <= Curr_State;
            end

//          Up            
            2'b11: begin
                if(BTNL) Next_State <= 2'b10;
                else if(BTNR) Next_State <= 2'b00;
                else Next_State <= Curr_State;
            end
            
            default: Next_State <= 2'b00;
        endcase
    end
    
//  Declare Nav_State as Curr_State for use in Rest of Program
    assign Nav_State = Curr_State;
endmodule