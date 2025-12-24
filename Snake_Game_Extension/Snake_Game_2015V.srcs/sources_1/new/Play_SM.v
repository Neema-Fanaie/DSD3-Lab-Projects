`timescale 1ns / 1ps

module Play_SM(
    input           Clk,
    input           Reset,
    input           BTNU,
    input           BTNR,
    input           BTNL,
    input           BTND,
    input   [1:0]   MSM_State,
    output  [1:0]   Play_State
    );
    
    reg [1:0]   Curr_State;
    reg [1:0]   Next_State;

    always@(posedge Clk) begin
        if(Reset) Curr_State <= 2'b00;
        else Curr_State <= Next_State;
    end
    
    always@(posedge Clk) begin
        if(Reset) Next_State <= 2'b00;
        else if(MSM_State == 2'b00) begin
            case(Curr_State)

//              Timed
                2'b00: begin
                    if(BTND) Next_State <= 2'b01;
                    else Next_State <= Curr_State;
                end

//              Untimed                
                2'b01: begin
                    if(BTNR) Next_State <= 2'b10;
                    else if (BTNL) Next_State <= 2'b00;
                    else Next_State <= Curr_State;
                end

//              Limitless                
                2'b10: begin
                    if(BTNU) Next_State <= 2'b01;
                    else Next_State <= Curr_State;
                end
                
                default: Next_State <= Curr_State;
            endcase
        end
    end
    
    assign Play_State = Curr_State;
endmodule
