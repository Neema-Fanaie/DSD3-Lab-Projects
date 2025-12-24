`timescale 1ns / 1ps

module VGA_Interface(
    input               Clk,
    input       [11:0]  Colour_In,
    output reg  [9:0]   AddrH,
    output reg  [8:0]   AddrV,
    output reg  [11:0]  Colour_Out,
    output reg          HS,
    output reg          VS
    );

    parameter VertTimeToPulseWidthEnd = 10'd2;
    parameter VertTimeToBackPorchEnd = 10'd31;
    parameter VertTimeToDisplayTimeEnd = 10'd511;
    parameter VertTimeToFrontPorchEnd = 10'd521;

    parameter HorzTimeToPulseWidthEnd = 10'd96;
    parameter HorzTimeToBackPorchEnd = 10'd144;
    parameter HorzTimeToDisplayTimeEnd = 10'd784;
    parameter HorzTimeToFrontPorchEnd = 10'd800;
 
    wire        Count_799Trig;
    wire        Count_520Trig;
    wire [9:0]  Counter_799;
    wire [9:0]  Counter_520;

//  Generate Counters for HS and VS
    Generic_Counter # (.Counter_Width(10),
                       .Counter_Max(799)
                      )
                      CounterHorizontal (
                       .Clk(Clk),
                       .Reset(1'b0),
                       .Enable(1'b1),
                       .Trig_Out(Count_799Trig),
                       .Count(Counter_799)
                      );

    Generic_Counter # (.Counter_Width(10),
                       .Counter_Max(520)
                      )
                      CounterVerticle (
                       .Clk(Clk),
                       .Reset(1'b0),
                       .Enable(Count_799Trig),
                       .Trig_Out(Count_520Trig),
                       .Count(Counter_520)
                      );

    // Define if counters are within display range
    assign WithinDisplayRangeHorz = Counter_799 >= HorzTimeToBackPorchEnd && Counter_799 < HorzTimeToDisplayTimeEnd;
    assign WithinDisplayRangeVert = Counter_520 >= VertTimeToBackPorchEnd && Counter_520 < VertTimeToDisplayTimeEnd;

    // Define if next horizontal counter will be within display range
    assign NextWithinDisplayRangeHorz = (Counter_799 + 1) >= HorzTimeToBackPorchEnd && (Counter_799 + 1)< HorzTimeToDisplayTimeEnd;

    // Increase HS and VS as required
    always@ (posedge Clk) begin    
        if (Counter_799 < HorzTimeToPulseWidthEnd) begin
            HS <= 0;
        end else begin
            HS <= 1;
        end
        
        if (Counter_520 < VertTimeToPulseWidthEnd) begin
            VS <= 0;
        end else begin
            VS <= 1;
        end
    end
    
    // Assigns Colour_Out to Colour_In or 0
    always@ (posedge Clk) begin
        if (WithinDisplayRangeHorz && WithinDisplayRangeVert) begin
            Colour_Out <= Colour_In;
        end else begin
            Colour_Out <= 0;
        end
    end

    // Calculate AddrH and AddrV
    always@ (posedge Clk) begin
        if (NextWithinDisplayRangeHorz && WithinDisplayRangeVert) begin
            AddrH <= Counter_799 - HorzTimeToBackPorchEnd + 2;
            AddrV <= Counter_520 - VertTimeToBackPorchEnd + 1;
        end else begin
            AddrH <= 0;
            AddrV <= 0;
        end
    end
endmodule
