module MIPS_Datapath (
    input [31:0] instruction,   // 32-bit instruction input
    input clk,                  // Clock signal
    input reset,                // Reset signal
    input regWrite, memWrite, memRead, // Control signals
    input branch,               // Branch control signal
    input [2:0] aluControl,     // ALU control signal
    output [31:0] aluResult,    // ALU result
    output [31:0] memDataOut,   // Memory read output
    output zero,                // Zero flag
    output [31:0] pc            // Program Counter
);

    // Internal signals
    reg [31:0] pc_reg; // Program Counter register
    wire [31:0] pc_next, pc_plus4, branch_target;
    wire [31:0] regData1, regData2, signExtImm, aluInput2;
    wire [31:0] branchOffset;
    wire branchTaken;

    // Initialize PC
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_reg <= 32'b0;
        else
            pc_reg <= pc_next;
    end

    assign pc = pc_reg;

    // PC + 4
    assign pc_plus4 = pc_reg + 4;

    // Sign extension for immediate value
    SignExtender signExtender (
        .in(instruction[15:0]),
        .out(signExtImm)
    );

    // Branch target calculation
    assign branchOffset = signExtImm << 2;
    assign branch_target = pc_plus4 + branchOffset;

    // Branch condition
    assign branchTaken = branch & zero;
    assign pc_next = branchTaken ? branch_target : pc_plus4;

    // Register File
    RegisterFile registerFile (
        .clk(clk),
        .regWrite(regWrite),
        .readReg1(instruction[25:21]),
        .readReg2(instruction[20:16]),
        .writeReg(instruction[15:11]),
        .writeData(aluResult),
        .readData1(regData1),
        .readData2(regData2)
    );

    // ALU input multiplexer
    Mux2to1 aluMux (
        .in0(regData2),
        .in1(signExtImm),
        .sel(instruction[28]), // Immediate selection
        .out(aluInput2)
    );

    // ALU
    ALU alu (
        .in1(regData1),
        .in2(aluInput2),
        .aluControl(aluControl),
        .result(aluResult),
        .zero(zero)
    );

    // Data Memory
    DataMemory dataMemory (
        .clk(clk),
        .memWrite(memWrite),
        .memRead(memRead),
        .address(aluResult),
        .writeData(regData2),
        .readData(memDataOut)
    );

endmodule

// Sign Extender Module
module SignExtender (
    input [15:0] in,
    output [31:0] out
);
    assign out = {{16{in[15]}}, in};
endmodule

// Register File Module
module RegisterFile (
    input clk,
    input regWrite,
    input [4:0] readReg1,
    input [4:0] readReg2,
    input [4:0] writeReg,
    input [31:0] writeData,
    output [31:0] readData1,
    output [31:0] readData2
);
    reg [31:0] registers [0:31];
    assign readData1 = registers[readReg1];
    assign readData2 = registers[readReg2];
    always @(posedge clk) begin
        if (regWrite)
            registers[writeReg] <= writeData;
    end
endmodule

// 2-to-1 Multiplexer Module
module Mux2to1 (
    input [31:0] in0,
    input [31:0] in1,
    input sel,
    output [31:0] out
);
    assign out = (sel) ? in1 : in0;
endmodule

// ALU Module
module ALU (
    input [31:0] in1,
    input [31:0] in2,
    input [2:0] aluControl,
    output reg [31:0] result,
    output zero
);
    always @(*) begin
        case (aluControl)
            3'b010: result = in1 + in2; // ADD
            3'b110: result = in1 - in2; // SUB
            3'b000: result = in1 & in2; // AND
            3'b001: result = in1 | in2; // OR
            default: result = 32'b0;
        endcase
    end
    assign zero = (result == 32'b0);
endmodule

// Data Memory Module
module DataMemory (
    input clk,
    input memWrite,
    input memRead,
    input [31:0] address,
    input [31:0] writeData,
    output [31:0] readData
);
    reg [31:0] memory [0:255];
    assign readData = (memRead) ? memory[address[7:0]] : 32'b0;
    always @(posedge clk) begin
        if (memWrite)
            memory[address[7:0]] <= writeData;
    end
endmodule
