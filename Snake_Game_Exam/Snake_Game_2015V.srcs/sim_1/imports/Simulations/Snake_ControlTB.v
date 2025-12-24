`timescale 1ns / 1ps

module Snake_ControlTB(
    );
    
    reg             Clk;
    reg             Reset;
    reg     [1:0]   MSM_State;
    reg     [1:0]   Nav_State;
    reg     [9:0]   X;
    reg     [8:0]   Y;
    wire            Reached_Target;
    wire    [11:0]  Colour;
    wire    [7:0]   Target_X;
    wire    [6:0]   Target_Y;
    
    Snake_Control uut1 (
        .Clk(Clk),
        .Reset(Reset),
        .MSM_State(MSM_State),
        .Nav_State(Nav_State),
        .X(X),
        .Y(Y),
        .Target_X(Target_X),
        .Target_Y(Target_Y),
        .Colour(Colour),
        .Reached_Target(Reached_Target)
    );
    
    Target_Generator uut2(
        .Clk(Clk),
        .Reset(Reset),
        .Reached_Target(Reached_Target),
        .Target_X(Target_X),
        .Target_Y(Target_Y)
    );
    
    parameter MaxX = 640;
    parameter MaxY = 480;
    
    initial begin 
        Clk = 0;
        forever #10 Clk = ~Clk;
    end
    
    initial begin
        X = 0;
        Y = 0;
        forever #10 begin
            if(X == MaxX) begin
                X = 0;
                if(Y == MaxY) Y = 0;
                else Y = Y + 1;
                
            end else X = X + 1;
        end
    end
    
    initial begin
        MSM_State = 2'b01; Nav_State = 2'b00;
        Reset = 1;
        #20 Reset = 0;
    end
endmodule
