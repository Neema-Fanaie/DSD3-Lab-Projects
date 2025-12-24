`timescale 1ns / 1ps

module Snake_Control(
    input               Clk,
    input               Reset,
    input       [1:0]   MSM_State,
    input       [1:0]   Nav_State,
    input       [9:0]   X,
    input       [8:0]   Y,
    input       [7:0]   Target_X,
    input       [6:0]   Target_Y,
    input               Game_Speed,
    output  reg [11:0]  Colour,
    output  reg         Reached_Target
    );
    
    integer i;
//  Parameters & Registers to Control Snake Dimensions
    reg [7:0] Snake_State_X [0:Snake_Length-1];
    reg [6:0] Snake_State_Y [0:Snake_Length-1];
    parameter Snake_Length  = 10;
    
//  Max Screen Dimensions
    parameter Max_X         = 159;
    parameter Max_Y         = 119;
    
//  Parameters and Registers to Control Screen Colours to Use in Game
    parameter Red       = 12'h00F;
    parameter Blue      = 12'h800;
    parameter Yellow    = 12'h0FF;
    parameter Green     = 12'h0F0;
    parameter Black     = 12'h000;
    parameter White     = 12'hFFF;   

//  Actions Depending on MSM State    
    always@(posedge Clk) begin
        if(Reset) begin
            Reached_Target <= 0;
       end
       else begin
            case(MSM_State)
    //          Idle State Play Screen, Pattern Copied from Another Source
                2'b00: begin
                    Colour <= White;
                    Reached_Target <= 0;
                end
                
    //          Play State
                2'b01: begin
                    
                    if(X[9:2] == Snake_State_X[0] && Y[8:2] == Snake_State_Y[0]) Colour <= Yellow;
                    else if(X[9:2] == Target_X && Y[8:2] == Target_Y) 
                        Colour <= Red;
                    else 
                        Colour <= Blue;
                    
                    for(i = 0; i < Snake_Length; i = i + 1) begin
                        if(X[9:2] == Snake_State_X[i] && Y[8:2] == Snake_State_Y[i]) Colour <= Yellow;
                    end
                    
                    if(Snake_State_X[0] == Target_X && Snake_State_Y[0] == Target_Y) begin
                        Reached_Target <= 1;
                    end 
                    else begin
                        Reached_Target <= 0;
                    end
                end
    
    //          Win Screen
                2'b10: begin
                    if (Y >= 0 && Y <= 120 || Y >= 240 && Y<= 360) Colour <= Green;
                    else Colour <= White;
                end
                default: begin 
                    Colour <= Red;
                    Reached_Target <= 0;
                end
                
           endcase
       end
    end
    
//    Generates Snake Counter Cycle   
    wire [24:0] Counter1;
    wire [24:0] Counter2;

//  Counters for Snake Speed
    Generic_Counter #   (   .Counter_Width(25),
                            .Counter_Max(5000000)
                        )   Snake_Update_Timer1(
                            .Clk(Clk),
                            .Reset(Reset),
                            .Enable(1'b1),
                            .Count(Counter1)
                        );
    Generic_Counter #   (   .Counter_Width(25),
                            .Counter_Max(2500000)
                        )   Snake_Update_Timer2(
                            .Clk(Clk),
                            .Reset(Reset),
                            .Enable(1'b1),
                            .Count(Counter2)
                        );
   
//  Generate Pixles for the Length of the Snake    
    genvar PixNo;
   
    generate
        for (PixNo = 0; PixNo < Snake_Length-1; PixNo = PixNo + 1) 
            begin: PixShift
            always@(posedge Clk) begin
                if(Reset) begin
                    Snake_State_X[PixNo + 1] <= 8'd80;
                    Snake_State_Y[PixNo + 1] <= 7'd100;  
                end else if(Game_Speed && Counter2 == 0) begin
                    Snake_State_X[PixNo + 1] <= Snake_State_X[PixNo];
                    Snake_State_Y[PixNo + 1] <= Snake_State_Y[PixNo];
                end else if(Counter1 == 0) begin
                    Snake_State_X[PixNo + 1] <= Snake_State_X[PixNo];
                    Snake_State_Y[PixNo + 1] <= Snake_State_Y[PixNo];                  
                end
            end  
        end
    endgenerate 

//  ----- Control Snake Movement ----- //
    always@(posedge Clk) begin
        if(Reset || MSM_State == 2'b00) begin
            Snake_State_X[0] <= 8'd80;
            Snake_State_Y[0] <= 7'd100;
        
// Push Next Position to Head of Snake When Counter & MSM Allow, Depending on NAV and Game_Speed
        end if(Game_Speed) begin
            if (Counter2 == 0 && MSM_State == 2'b01) begin
                case(Nav_State) 
//                  Right
                    2'b00: begin
                        if(Snake_State_X[0] == Max_X) Snake_State_X[0]  <= 0;
                        else Snake_State_X[0] <= Snake_State_X[0] + 1;
                    end
    
//                  Down                
                    2'b01: begin
                        if(Snake_State_Y[0] == 0) Snake_State_Y[0]  <= Max_Y;
                        else Snake_State_Y[0] <= Snake_State_Y[0] - 1;
                    end
                    
//                  Left
                    2'b10: begin
                        if(Snake_State_X[0] == 0) Snake_State_X[0]  <= Max_X;
                        else Snake_State_X[0] <= Snake_State_X[0] - 1;
                    end
    
//                  Up                
                    2'b11: begin
                        if(Snake_State_Y[0] == Max_Y) Snake_State_Y[0]  <= 0;
                        else Snake_State_Y[0] <= Snake_State_Y[0] + 1;
                    end
               endcase
            end
        end else begin
           if (Counter1 == 0 && MSM_State == 2'b01) begin
               case(Nav_State) 
//                  Right
                   2'b00: begin
                       if(Snake_State_X[0] == Max_X) Snake_State_X[0]  <= 0;
                       else Snake_State_X[0] <= Snake_State_X[0] + 1;
                   end
   
//                  Down                
                   2'b01: begin
                       if(Snake_State_Y[0] == 0) Snake_State_Y[0]  <= Max_Y;
                       else Snake_State_Y[0] <= Snake_State_Y[0] - 1;
                   end
                   
//                  Left
                   2'b10: begin
                       if(Snake_State_X[0] == 0) Snake_State_X[0]  <= Max_X;
                       else Snake_State_X[0] <= Snake_State_X[0] - 1;
                   end
   
//                  Up                
                   2'b11: begin
                       if(Snake_State_Y[0] == Max_Y) Snake_State_Y[0]  <= 0;
                       else Snake_State_Y[0] <= Snake_State_Y[0] + 1;
                   end
                   
              endcase
           end
       end
    end
endmodule