`timescale 1ns / 1ps

module VGA_Display2(
    input CLK,
    input [11:0] Colour_In,
    output reg [9:0] AddrH,
    output reg [8:0] AddrV,
    output reg [11:0] Colour_Out,
    output reg HS,
    output reg VS
    );

    parameter VertTimeToPulseWidthEnd = 10'd2;
    parameter VertTimeToBackPorchEnd = 10'd31;
    parameter VertTimeToDisplayTimeEnd = 10'd511;
    parameter VertTimeToFrontPorchEnd = 10'd521;

    parameter HorzTimeToPulseWidthEnd = 10'd96;
    parameter HorzTimeToBackPorchEnd = 10'd144;
    parameter HorzTimeToDisplayTimeEnd = 10'd784;
    parameter HorzTimeToFrontPorchEnd = 10'd800;
 
    wire Horz_Trig;
    wire Vert_Trig;
    wire [9:0] Horz_Count;
    wire [9:0] Vert_Count;

    Generic_counter # (.Counter_Width(10),
                       .Counter_Max(799)
                      )
                      Width_Counter (
                       .Clk(CLK),
                       .Reset(1'b0),
                       .Enable(1'b1),
                       .Trig_Out(Horz_Trig),
                       .Count(Horz_Count)
                      );

    Generic_counter # (.Counter_Width(10),
                       .Counter_Max(520)
                      )
                      Height_Counter (
                       .Clk(CLK),
                       .Reset(1'b0),
                       .Enable(Horz_Trig),
                       .Trig_Out(Vert_Trig),
                       .Count(Vert_Count)
                      );

    // Define if counters are within display range
    assign WithinDisplayRangeHorz = Horz_Count >= HorzTimeToBackPorchEnd && Horz_Count < HorzTimeToDisplayTimeEnd;
    assign WithinDisplayRangeVert = Vert_Count >= VertTimeToBackPorchEnd && Vert_Count < VertTimeToDisplayTimeEnd;

    // Define if next horizontal counter will be within display range
    assign NextWithinDisplayRangeHorz = (Horz_Count + 1) >= HorzTimeToBackPorchEnd && (Horz_Count + 1)< HorzTimeToDisplayTimeEnd;

    // Increase HS and VS as required
    always@ (posedge CLK) begin    
        if (Horz_Count < HorzTimeToPulseWidthEnd) begin
            HS <= 0;
        end else begin
            HS <= 1;
        end
        
        if (Vert_Count < VertTimeToPulseWidthEnd) begin
            VS <= 0;
        end else begin
            VS <= 1;
        end
    end
    
    // Assigns COLOUR_OUT to COLOUR_IN or 0
    always@ (posedge CLK) begin
        if (WithinDisplayRangeHorz && WithinDisplayRangeVert) begin
            Colour_Out <= Colour_In;
        end else begin
            Colour_Out <= 0;
        end
    end

    // Calculate ADDRH and ADDRV
    always@ (posedge CLK) begin
        if (NextWithinDisplayRangeHorz && WithinDisplayRangeVert) begin
            AddrH <= Horz_Count - HorzTimeToBackPorchEnd + 2;
            AddrV <= Vert_Count - VertTimeToBackPorchEnd + 1;
        end else begin
            AddrH <= 0;
            AddrV <= 0;
        end
    end
endmodule
