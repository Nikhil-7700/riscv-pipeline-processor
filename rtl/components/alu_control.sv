// ========================================================================
// Module: alu_control.sv
// Description: ALU Control for RISC-V RV32I (EX Stage)
// Author: Padmanabha Nikhil
// ========================================================================

// ===================================================================
// | alu_op | funct3 | funct7[5] |       Operation     | alu_control |
// |--------|--------|-----------|---------------------|-------------|
// |   00   |   xxx  |     x     | ADD (load/store/JAL)|     0000    |
// |   01   |   xxx  |     x     |   SUB (for branch)  |     0001    |
// |   10   |   000  |     0     |         ADD         |     0000    |
// |   10   |   000  |     1     |         SUB         |     0001    |
// |   10   |   001  |     x     |         SLL         |     0101    |
// |   10   |   010  |     x     |         SLT         |     1000    |
// |   10   |   011  |     x     |         SLTU        |     1001    |
// |   10   |   100  |     x     |         XOR         |     0100    |
// |   10   |   101  |     0     |         SRL         |     0110    |
// |   10   |   101  |     1     |         SRA         |     0111    |
// |   10   |   110  |     x     |         OR          |     0011    |
// |   10   |   111  |     x     |         AND         |     0010    |
// ===================================================================


module alu_control(
  input logic [1:0] alu_op,
  input logic [2:0] funct3,
  input logic funct7_5,
  
  output logic [3:0] alu_control
);


  always_comb begin
  
    casex( {alu_op, funct3, funct7_5} )
	
	  6'b00xxxx: alu_control = 4'b0000;		// ADD (load/store/JAL)
	  6'b01xxxx: alu_control = 4'b0001;     // SUB (for branch)  
	  6'b100000: alu_control = 4'b0000;     // ADD         
	  6'b100001: alu_control = 4'b0001;     // SUB         
	  6'b10001x: alu_control = 4'b0101;     // SLL         
	  6'b10010x: alu_control = 4'b1000;     // SLT         
	  6'b10011x: alu_control = 4'b1001;     // SLTU        
	  6'b10100x: alu_control = 4'b0100;     // XOR         
	  6'b101010: alu_control = 4'b0110;     // SRL         
	  6'b101011: alu_control = 4'b0111;     // SRA         
	  6'b10110x: alu_control = 4'b0011;     // OR          
	  6'b10111x: alu_control = 4'b0010;     // AND         
	  default: alu_control = 4'b0000;

    endcase	
  
  end



endmodule