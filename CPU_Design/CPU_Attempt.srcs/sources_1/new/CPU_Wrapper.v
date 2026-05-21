`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Univeristy of Edinburgh
// Engineer: Neema Fanaie
// 
// Create Date: 10.01.2026 12:20:57
// Design Name: 
// Module Name: CPU_Wrapper
// Project Name: CPU_Attempt
// Target Devices: Basys3 Board
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CPU_Wrapper(
    input               Clk,
    input               Enable_Switch,
    input       [3:0]   In,
    output  reg [3:0]   Out
    );

// ----- Main Cycles: Fetch Decode Execute ----- //

// Need: Registers for PC, MAR, MDR, ACC, and RAM

// Define RAM as a 16-bit Array where each item in the array has 8 bits
    reg [7:0] RAM [0:15];
// Program RAM here at the start of every program
    initial begin
//        RAM[0] = 8'b10100101;   // Store to location A
//        RAM[1] = 8'b10110110;   // Load value from location B to ACC 
//        RAM[2] = 8'b00010101;   // Add value from A to ACC
//        RAM[3] = 8'b10100111;   // Store new value to location C
//        RAM[4] = 8'b01000000;   // Output Result
//        RAM[5] = 8'b00000000;
//        RAM[6] = 8'b00000100;
//        RAM[7] = 8'b00000000;
        RAM[0] = 8'b10100101;   // Store to location A
        RAM[1] = 8'b00110000;   // Take Input From User
        RAM[2] = 8'b00100101;   // Subtract Value at Location A from ACC
        RAM[3] = 8'b01000000;   // Output Result
        RAM[4] = 8'b00000000;   
        RAM[5] = 8'b00000000;   // Location A
        PC = 0;
        ACC = 4'd2;
    end
// Each address is therefore 4 bits, so PC and MAR need to accomodate:
    reg [3:0] PC; // Initialised at 0 for every program 
    reg [3:0] MAR; 
// MDR Needs to hold full data and instructions from RAM
    reg [7:0] MDR;
// Opcode and Operand for ALU Module
    reg [3:0] Opcode;
    reg [3:0] Operand;
// ACC to Store Current Values
    reg [3:0] ACC;    
//Fetch Block:
//  -- Address copied from PC -> MAR
//  -- Data @ Address copied to MDR
//  -- PC += 1
    reg Enable;
    always@(posedge Clk) begin
        if(Enable) begin
            MAR = PC;
            MDR = RAM[MAR];
            PC = PC + 1;
        end
    end
    
//Decode Block:
//  -- MDR Split into Opcode and Operand 
//  -- Prep for execute
    always@(posedge Clk) begin
        Opcode  = MDR[7:4];
        Operand = MDR[3:0]; 
    end

// ACC Controls Based on Opcode 
    always@(posedge Clk) begin
        case(Opcode)
//          Halt Program
            4'b0000: Enable = 0;
//          Add From Address of Operand to Value in ACC
            4'b0001: begin
                ACC = ACC + RAM[Operand][3:0];
                Enable = 1;
            end
//          Sub From Value in ACC
            4'b0010: begin
                ACC = ACC - RAM[Operand][3:0];
                Enable = 1;
            end
//          Take an Input
            4'b0011: begin
                if(Enable_Switch) begin
                    ACC = In;
                    Enable = 1;
                end
                else Enable = 0;
            end
//          Give an Output
            4'b0100: begin
                Out = ACC;
                Enable = 1;
            end
//          Less Than (<)
            4'b0101: ;
//          Less Than or Equal to (<=)
            4'b0110: ;
//          Greater Than (>)
            4'b0111: ;
//          Greater Than or Equal To (>=)
            4'b1000: ;
//          Equal to (==)
            4'b1001: ;
//          Store 
            4'b1010: begin
                RAM[Operand][3:0] = ACC;
                Enable = 1;
            end
//          Load
            4'b1011: begin
                ACC = RAM[Operand][3:0];
                Enable = 1;
            end
//          AND
            4'b1100: ;
//          OR
            4'b1101: ;
//          XOR
            4'b1110: ;
//          NOT
            4'b1111: ;
            default: Enable = 1;
        endcase 
    end
endmodule
