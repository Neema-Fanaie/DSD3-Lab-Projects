`timescale 1ns / 1ps

module Target_Generator(
    input               Clk,
    input               Reset,
    input               Reached_Target,
    output  reg [7:0]   Target_X,
    output  reg [6:0]   Target_Y
    );
//  Registers for Each LFSR
    reg [7:0] LFSR_1_Out;
    reg [6:0] LFSR_2_Out;
    
    always@(posedge Clk) begin
        if (Reset) begin
            LFSR_1_Out <= 8'd80;
            LFSR_2_Out <= 7'd70;
        end else begin
            LFSR_1_Out[7:1] <= LFSR_1_Out[6:0];
            LFSR_1_Out[0]   <= ~(~(LFSR_1_Out[7] ^ LFSR_1_Out[5]) ^ ~(LFSR_1_Out[4] ^ LFSR_1_Out[3]));
            
            LFSR_2_Out[6:1] <=  LFSR_2_Out[5:0];
            LFSR_2_Out[0]   <= ~(LFSR_2_Out[6] ^ LFSR_2_Out[5]);
        end
    end
    
    always@(posedge Clk) begin
        if(Reset) begin
            Target_X <= 8'd80;
            Target_Y <= 7'd70;
        end else begin   
            
            if (Reached_Target) begin
            
                if(LFSR_1_Out > 155)    
                    Target_X <= LFSR_1_Out - 155; //{1'b0, LFSR_1_Out[7:0]};
                else                            
                    Target_X <= LFSR_1_Out;
                    
                if (LFSR_2_Out > 115)   
                    Target_Y <= LFSR_2_Out - 115; //{1'b0, LFSR_2_Out[6:0]};
                else
                    Target_Y <= LFSR_2_Out;
            
            end else begin
                Target_X <= Target_X;
                Target_Y <= Target_Y;
            end
        end
    end
    
endmodule