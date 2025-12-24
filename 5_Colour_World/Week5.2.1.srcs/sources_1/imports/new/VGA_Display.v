`timescale 1ns / 1ps

module VGA_Display(
    // Inputs 
    input Clk,
    input Clk_25,
    input Reset,
    // Outputs
    output Video_On,
    output [9:0] AddrH,
    output [9:0] AddrV,
    output HS,
    output VS
    );
    
    
    parameter HD = 640;
    parameter HF = 48;
    parameter HB = 16;
    parameter HR = 96;
    parameter H_Max = HD+HF+HB+HR-1;
    
    parameter VD = 480;
    parameter VF = 10;
    parameter VB = 33;
    parameter VR = 2;
    parameter V_Max = VD + VF + VB + VR - 1;
    
    reg [9:0] H_Count_Reg, H_Count_Next;
    reg [9:0] V_Count_Reg, V_Count_Next;
    
    reg V_Sync_Reg, H_Sync_Reg;
    wire V_Sync_Next, H_Sync_Next;
   
    always@(posedge Clk or posedge Reset) begin
        if(Reset) begin
            V_Count_Reg <= 0;
            H_Count_Reg <= 0;
            V_Sync_Reg <= 1'b0;
            H_Sync_Reg <= 1'b0;           
        end
        else begin
            V_Count_Reg <= V_Count_Next;
            H_Count_Reg <= H_Count_Next;
            V_Sync_Reg <= V_Sync_Next;
            H_Sync_Reg <= H_Sync_Next;
        end
    end
    
    always@(posedge Clk_25 or posedge Reset) begin
        if(Reset) begin
            H_Count_Next = 0;
            V_Count_Next = 0;
        end
        else begin
            if(H_Count_Reg == H_Max) begin
                H_Count_Next = 0;
                if(V_Count_Reg == V_Max) V_Count_Next = 0;
                else V_Count_Next = V_Count_Reg + 1; 
            end
            else H_Count_Next = H_Count_Reg + 1;
        end
    end
    
//    always@(posedge Clk_25 or posedge Reset) begin
//        if(Reset) V_Count_Next = 0;
//        else begin
//            if(H_Count_Reg == H_Max) begin
//                if(V_Count_Reg == V_Max) V_Count_Next = 0;
//                else V_Count_Next = V_Count_Reg + 1;         
//            end
//        end 
//    end
    
    assign H_Sync_Next = (H_Count_Reg >= (HD + HB) && H_Count_Reg <= (HD+HB+HR-1));
    assign V_Sync_Next = (V_Count_Reg >= (VD + VB) && V_Count_Reg <= (VD+VB+VR-1));
    assign Video_On = (H_Count_Reg < HD) && (V_Count_Reg < VD);
    
    assign HS = H_Sync_Reg;
    assign VS = V_Sync_Reg;
    assign AddrH = H_Count_Reg;
    assign AddrV = V_Count_Reg; 
endmodule
