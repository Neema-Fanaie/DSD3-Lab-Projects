`timescale 1ns / 1ps

module MSM(
    input           Clk,
    input           Reset,
    input           BTNU,
    input           BTNL,
    input           BTNR,
    input           BTND,
    input           Enable,
    input   [7:0]   Current_Score,
    input   [7:0]   Current_Time,
    input   [1:0]   Play_State,
    output  [1:0]   MSM_State
    );
/*  State Assignments:
    00001 - Idle 
    
*/
    reg [1:0] Curr_State;
    reg [1:0] Next_State;
    
//  Current-State Logic
    always@(posedge Clk or posedge Reset) begin
        if (Reset) Curr_State <= 2'b00;
        else Curr_State <= Next_State;
    end

//  Next-State Logic  
    always@(Curr_State or Reset or Current_Score or BTNU or BTNR or BTND or BTNL) begin
        case(Curr_State)
//          Idle State
            2'b00: begin
                if((BTNU || BTND || BTNL || BTNR) && Enable) Next_State <= 2'b01;
                else Next_State <= Curr_State;
            end
           
//          Play State
            2'b01: begin
                /*
                    Win State only triggerd if not in limitless && score of 10
                    Lose State only triggerd if timed mode and time reaches 60s
                    Else Continue
                */
                if(Current_Score == 8'h10 && (Play_State == 2'b00 || Play_State == 2'b01)) Next_State <= 2'b10;
                else if((Current_Time == 8'h60) && (Play_State == 2'b00)) Next_State <= 2'b11;
                else if(Reset) Next_State <= 2'b00;
                else Next_State <= Curr_State;
            end
            
//          Win State
            2'b10: begin
                if(Reset) Next_State <= 2'b00;
                else Next_State <= Curr_State;
            end

//            Lose State
            2'b11: begin
                if(Reset) Next_State <= 2'b00;
                else Next_State <= Curr_State;            
            end
            
            default: Next_State <= 2'b00;
        endcase 
    end

//  Assign MSM_State Variable to Curr_State to use in Rest of Program
    assign MSM_State = Curr_State;
endmodule
