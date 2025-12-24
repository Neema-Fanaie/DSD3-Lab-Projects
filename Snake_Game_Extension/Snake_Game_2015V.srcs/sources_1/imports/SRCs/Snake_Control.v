`timescale 1ns / 1ps

module Snake_Control(
    input               Clk,
    input               Reset,
    input       [1:0]   MSM_State,
    input       [1:0]   Nav_State,
    input       [1:0]   Play_State,
    input       [9:0]   X,
    input       [8:0]   Y,
    input       [7:0]   Target_X,
    input       [6:0]   Target_Y,
    output  reg [11:0]  Colour,
    output  reg         Reached_Target
    );
    
    integer i;
//  Parameters & Registers to Control Snake Dimensions
    reg [5:0] Snake_Var;    
    reg [7:0] Snake_State_X [0:Snake_Length-1];
    reg [6:0] Snake_State_Y [0:Snake_Length-1];

    parameter Snake_Length  = 20;
    parameter Small_Snake   = 6;
    
//  Max Screen Dimensions
    parameter Max_X         = 159;
    parameter Max_Y         = 119;
    
//  Parameters and Registers to Control Screen Colours to Use in Game
    parameter Red       = 12'h00F;
    parameter Blue      = 12'h800;
    parameter Yellow    = 12'h0FF;
    parameter Green     = 12'h0F0;
    parameter Black     = 12'h000;
    
    reg [15:0] Frame_Count;
    reg [7:0] Win_Reg;

//  Actions Depending on MSM State    
    always@(posedge Clk) begin
        if(Reset) begin
            Reached_Target <= 0;
            Snake_Var <= Small_Snake;
        end
        else begin
            case(MSM_State)
    //          Idle State Play Screen, Pattern Copied from Another Source
                2'b00:  begin
//    //               Letter P
//                     if((X >= 100 && X <= 110 && Y >= 120 && Y <= 360) ||
//                        (X >= 110 && X <= 190 && Y >= 120 && Y <= 130) ||
//                        (X >= 180 && X <= 190 && Y >= 130 && Y <= 200) ||
//                        (X >= 110 && X <= 190 && Y >= 200 && Y <= 210) ||
//    //               Letter L             
//                        (X >= 220 && X <= 230 && Y >= 120 && Y <= 360) ||
//                        (X >= 230 && X <= 320 && Y >= 350 && Y <= 360) ||
//    //               Letter A                
//                        (X >= 350 && X <= 360 && Y >= 130 && Y <= 360) ||
//                        (X >= 360 && X <= 420 && Y >= 120 && Y <= 130) ||
//                        (X >= 360 && X <= 420 && Y >= 200 && Y <= 210) ||
//                        (X >= 420 && X <= 430 && Y >= 130 && Y <= 360) ||
//    //               Letter Y             
//                        (X >= 460 && X <= 470 && Y >= 120 && Y <= 200) ||
//                        (X >= 470 && X <= 530 && Y >= 200 && Y <= 210) ||
//                        (X >= 530 && X <= 540 && Y >= 120 && Y <= 350) ||
//                        (X >= 470 && X <= 530 && Y >= 350 && Y <= 360))        
//                        Colour <= Red;
//                    else begin
//                        Colour <= Black;
//                        Reached_Target <= 0;
//                        Snake_Var <= Small_Snake;
//                    end
                    case(Play_State)
                        2'b00: begin
                            if(X[9:2] <= 53) Colour <= Red;
                            else if(X[9:2] <= 107) Colour <= Black;
                            else Colour <= Black;
                        end
                        
                        2'b01: begin
                            if(X[9:2] <= 53) Colour <= Black;
                            else if(X[9:2] <= 107) Colour <= Red;
                            else Colour <= Black;
                        end
                        
                        2'b10: begin
                            if(X[9:2] <= 53) Colour <= Black;
                            else if(X[9:2] <= 107) Colour <= Black;
                            else Colour <= Red;
                        end
                    endcase
                end
                
    //          Play State
                2'b01: begin
                    
                    if(X[9:2] == Snake_State_X[0] && Y[8:2] == Snake_State_Y[0]) Colour <= Green;
                    else if(X[9:2] == Target_X && Y[8:2] == Target_Y) 
                        Colour <= Red;
                    else 
                        Colour <= Blue;
                    
                    for(i = 0; i < Snake_Var; i = i + 1) begin
                        if(X[9:2] == Snake_State_X[i] && Y[8:2] == Snake_State_Y[i]) Colour <= Green;
                    end
                    
                    if(Snake_State_X[0] == Target_X && Snake_State_Y[0] == Target_Y) begin
                        Reached_Target <= 1;
                        
                        if(Snake_Var < Snake_Length) Snake_Var <= Snake_Var + 1; 
                    end 
                    else Reached_Target <= 0;
                end
    
    //          Win Screen
                2'b10: begin
                    if(Y == 479) Frame_Count <= Frame_Count + 1;
                    
                        
                    if (Y[8:0] > 240) begin
                        if (X[9:0] > 320)
                            Win_Reg <= Frame_Count[15:8] + Y[7:0] + X[7:0] - 240 - 320;
                        else
                            Win_Reg <= Frame_Count[15:8] + Y[7:0] - X[7:0] - 240 + 320; 
                    end 
                    else begin
                        if (X[9:0] > 320)
                            Win_Reg <= Frame_Count[15:8] - Y[7:0] + X[7:0] + 240 - 320;  
                        else 
                            Win_Reg <= Frame_Count[15:8] - Y[7:0] - X[7:0] + 240 + 320;
                    end
                    Colour <= {4'b0, Win_Reg};
                
                end
                default: begin 
                    Colour <= Red;
                    Reached_Target <= 0;
                end
                
                2'b11: Colour <= Red;
                
           endcase
       end
    end
    
//    Generates Snake Counter Cycle   
    wire [24:0] Counter;
    Generic_Counter #   (   .Counter_Width(25),
                            .Counter_Max(5000000)
                        )   Counter_1(
                            .Clk(Clk),
                            .Reset(Reset),
                            .Enable(1'b1),
                            .Count(Counter)
                        );
    
    genvar PixNo;
    
    generate
        for (PixNo = 0; PixNo < Snake_Length-1; PixNo = PixNo + 1) 
            begin: PixShift
            always@(posedge Clk) begin
                if(Reset) begin
                    Snake_State_X[PixNo + 1] <= 80;
                    Snake_State_Y[PixNo + 1] <= 100;  
                end else if(Counter == 0) begin
                    Snake_State_X[PixNo + 1] <= Snake_State_X[PixNo];
                    Snake_State_Y[PixNo + 1] <= Snake_State_Y[PixNo];
                end
            end  
        end
    endgenerate 

//  ----- Control Snake Movement ----- //
    always@(posedge Clk) begin
        if(Reset) begin
            Snake_State_X[0] <= 80;
            Snake_State_Y[0] <= 100;
        
        // Push Next Position to Head of Snake When Counter & MSM Allow, Depending on NAV
        end else if (Counter == 0 && MSM_State == 2'b01) begin
            case(Nav_State) 
//                Right
                2'b00: begin
                    if(Snake_State_X[0] == Max_X) Snake_State_X[0]  <= 0;
                    else Snake_State_X[0] <= Snake_State_X[0] + 1;
                end

//                Down                
                2'b01: begin
                    if(Snake_State_Y[0] == 0) Snake_State_Y[0]  <= Max_Y;
                    else Snake_State_Y[0] <= Snake_State_Y[0] - 1;
                end
                
//                Left
                2'b10: begin
                    if(Snake_State_X[0] == 0) Snake_State_X[0]  <= Max_X;
                    else Snake_State_X[0] <= Snake_State_X[0] - 1;
                end

//                Up                
                2'b11: begin
                    if(Snake_State_Y[0] == Max_Y) Snake_State_Y[0]  <= 0;
                    else Snake_State_Y[0] <= Snake_State_Y[0] + 1;
                end
                
           endcase
        end
    end
endmodule