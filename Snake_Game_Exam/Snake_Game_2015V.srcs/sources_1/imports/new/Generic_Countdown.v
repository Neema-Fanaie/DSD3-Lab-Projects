`timescale 1ns / 1ps

module Generic_Countdown(
    Clk,
    Reset,
    Enable,
    Trig_Out,
    Count
    );
    
    parameter Counter_Width = 4;
    parameter Counter_Max   = 9;
    parameter Start_Value   = 9;
    
    input Clk;
    input Reset;
    input Enable;
    output Trig_Out;
    output [Counter_Width-1:0] Count;
    
    reg [Counter_Width-1:0] Count_Value;
    reg Trigger_Out;
    
    // Control value of Count_Value
    always@(posedge Clk) begin
        if(Reset) Count_Value <= Start_Value;
        else begin
            if(Enable) begin
                if(Count_Value == 0) Count_Value <= Counter_Max;
                else Count_Value <= Count_Value - 1;
            end
        end
    end
    
    // Control Trigger_Out
    always@(posedge Clk) begin
        if(Reset) Trigger_Out <= 0;
        else begin 
            if(Enable && (Count_Value == 0)) Trigger_Out <= 1;
            else Trigger_Out <= 0;
        end    
    end  
    
    // attach Trigger_Out and Count_Value to Trig_Out and Count respecitvly
    assign Count = Count_Value;
    assign Trig_Out = Trigger_Out;
 
endmodule
