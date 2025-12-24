`timescale 1ns / 1ps

// Input and Output Manager, This file only contains modules and the wires connecting them
module Input_Output(
//  Inputs
    input           Clk,
    input           Reset,
    input           BTNU,
    input           BTNL,
    input           BTNR,
    input           BTND,
    input           Game_Speed,
// Outputs
    output  [3:0]   Seg_Select,
    output  [7:0]   Hex_Out, 
    output  [11:0]  Colour_Out,
    output          HS,
    output          VS
    );

/* ----- Wires for Connections Between Modules ----- */
    wire [1:0]  MSM_State;      
    wire [1:0]  Nav_State;      
    wire [1:0]  Strobe_Counter;
    wire [7:0]  Current_Score; 
    wire [7:0]  Current_Time;
// TODO: Seperate FrameGen code from Snake Control
    wire [9:0]  X;              
    wire [8:0]  Y;
    wire [7:0]  Target_X;
    wire [6:0]  Target_Y;
// TODO: Don't need, same as above TODO
    wire [11:0] Colour;
    wire        Reached_Target; 

// ----- Control Idle, Play and Win States ----- //
    MSM Master_SM(
        .Clk(Clk),
        .Reset(Reset),
        .BTNU(BTNU),
        .BTNL(BTNL),
        .BTNR(BTNR),
        .BTND(BTND),
        .Current_Score(Current_Score),
        .Current_Time(Current_Time),
        .MSM_State(MSM_State)
    );
    
// ----- Direction of the Snake during Play State ----- //
    Navigation_State_Machine Nav_SM(
        .Clk(Clk),
        .Reset(Reset),
        .BTNU(BTNU),
        .BTNL(BTNL),
        .BTNR(BTNR),
        .BTND(BTND),
        .Nav_State(Nav_State)
    );

// ----- Main body of Program, Controls Snake Position and Display ----- //
    Snake_Control Snake(
        .Clk(Clk),
        .Reset(Reset),
        .MSM_State(MSM_State),
        .Nav_State(Nav_State),
        .X(X),
        .Y(Y),
        .Target_X(Target_X),
        .Target_Y(Target_Y),
        .Game_Speed(Game_Speed),
        .Colour(Colour),
        .Reached_Target(Reached_Target)
    );

// ----- VGA Prorgam, Controls VGA Related outputs ----- //
    VGA_Program VGA_Control(
        .Clk(Clk),
        .Colour(Colour),
        .X(X),
        .Y(Y),
        .Colour_Out(Colour_Out),
        .HS(HS),
        .VS(VS)
    );

// ----- Generates a Target When Previous one is Eaten ----- //
    Target_Generator Target_Control(
        .Clk(Clk),
        .Reset(Reset),
        .MSM_State(MSM_State),
        .Reached_Target(Reached_Target),
        .Target_X(Target_X),
        .Target_Y(Target_Y)    
    );

// ----- Updates Score and Generates Strobe Counter ----- //
    Score_Counter SC(
        .Clk(Clk),
        .Reset(Reset),
        .MSM_State(MSM_State),
        .Reached_Target(Reached_Target),
        .Current_Score(Current_Score)
    );
    
// ----- Control the Current Time ----- //
    Timer Time_Control(
        .Clk(Clk),
        .Reset(Reset),
        .MSM_State(MSM_State),
        .Current_Time(Current_Time)
    );
    
// ----- Control the 7-Segment Displays ----- //
    Seg7_Wrapper Seg7Control(
        .Clk(Clk),
        .Reset(Reset),
        .Current_Score(Current_Score),
        .Current_Time(Current_Time),
        .Seg_Select(Seg_Select),
        .Hex_Out(Hex_Out)
    );
    
endmodule