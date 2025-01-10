`include "MIPS_Datapath.v"
module MIPS_Datapath_tb;
    // Inputs
    reg clk;
    reg reset;
    reg regWrite;
    reg memWrite;
    reg memRead;
    reg branch;
    reg [2:0] aluControl;
    reg [31:0] instruction;

    // Outputs
    wire [31:0] aluResult;
    wire [31:0] memDataOut;
    wire zero;
    wire [31:0] pc;

    // Memory for simulation
    reg [31:0] memory [0:31]; // 32 words of memory

    // Instantiate the Unit Under Test (UUT)
    MIPS_Datapath uut (
        .instruction(instruction),
        .clk(clk),
        .reset(reset),
        .regWrite(regWrite),
        .memWrite(memWrite),
        .memRead(memRead),
        .branch(branch),
        .aluControl(aluControl),
        .aluResult(aluResult),
        .memDataOut(memDataOut),
        .zero(zero),
        .pc(pc)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("waveform.vcd"); 
        $dumpvars(0, MIPS_Datapath_tb); 
    end
    
    // Test cases
    initial begin
        // Initialize inputs
        reset = 1;
        regWrite = 0;
        memWrite = 0;
        memRead = 0;
        branch = 0;
        aluControl = 3'b000;
        instruction = 32'b0;

        // Initialize memory
        memory[1] = 1;
        memory[2] = 2;
        memory[4] = 4;
        memory[5] = 5;
        #10;

        reset = 0;

        // Test R-type instruction (ADD: opcode = 0, funct = 32)
        instruction = 32'b000000_00001_00010_00011_00000_100000; // ADD $3, $1, $2
        regWrite = 1;
        aluControl = 3'b010; // ADD operation
        #10;

        // Validate output for ADD
        if (aluResult !== (memory[1] + memory[2])) $display("ADD test failed");

        // Test R-type instruction (SUB: opcode = 0, funct = 34)
        instruction = 32'b000000_00100_00101_00110_00000_100010; // SUB $6, $4, $5
        regWrite = 1;
        aluControl = 3'b110; // SUB operation
        #10;

        // Validate output for SUB
        if (aluResult !== (memory[4] - memory[5])) $display("SUB test failed");

        // Test R-type instruction (AND: opcode = 0, funct = 36)
        instruction = 32'b000000_00011_00001_00111_00000_100100; // AND $7, $3, $1
        regWrite = 1;
        aluControl = 3'b000; // AND operation
        #10;

        // Validate output for AND
        if (aluResult !== (memory[3] & memory[1])) $display("AND test failed");

        // Test R-type instruction (OR: opcode = 0, funct = 37)
        instruction = 32'b000000_00101_00100_01000_00000_100101; // OR $8, $5, $4
        regWrite = 1;
        aluControl = 3'b001; // OR operation
        #10;

        // Validate output for OR
        if (aluResult !== (memory[5] | memory[4])) $display("OR test failed");

        // Test I-type instruction (LW: opcode = 35)
        instruction = 32'b100011_00001_00100_0000_0000_0000_0100; // LW $4, 4($1)
        memRead = 1;
        regWrite = 1;
        aluControl = 3'b010; // ADD for address calculation
        #10;

        // Validate output for LW
        if (memDataOut !== memory[memory[1] + 4]) $display("LW test failed");

        // Test I-type instruction (SW: opcode = 43)
        instruction = 32'b101011_00001_00101_0000_0000_0000_1000; // SW $5, 8($1)
        memWrite = 1;
        regWrite = 0;
        aluControl = 3'b010; // ADD for address calculation
        #10;

        // Validate output for SW (Check memory content)
        if (memory[memory[1] + 8] !== memory[5]) $display("SW test failed");

        // Test J-type instruction (J: opcode = 2)
        instruction = 32'b000010_00000_00000_00000_00000_001010; // J 10
        branch = 1;
        aluControl = 3'b010; // PC update
        #10;

        // Validate PC for J
        if (pc !== 10) $display("J test failed");

        // Test J-type instruction (J: opcode = 2, different target)
        instruction = 32'b000010_00000_00000_00000_00000_001100; // J 12
        branch = 1;
        aluControl = 3'b010; // PC update
        #10;

        // Validate PC for J
        if (pc !== 12) $display("J (different target) test failed");

        // Finish simulation
        $stop;
    end
endmodule
