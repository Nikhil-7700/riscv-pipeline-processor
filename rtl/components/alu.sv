// ========================================================================
// Module: alu.sv
// Description: 32-bit Arithmetic Logic Unit for RISC-V RV32I (EX Stage)
// Author: Padmanabha Nikhil
// ========================================================================


// ========================================================================
// ALU Operations
// ========================================================================
// 4'b0000 - ADD   : result = a + b
// 4'b0001 - SUB   : result = a - b
// 4'b0010 - AND   : result = a & b
// 4'b0011 - OR    : result = a | b
// 4'b0100 - XOR   : result = a ^ b
// 4'b0101 - SLL   : result = a << b[4:0]
// 4'b0110 - SRL   : result = a >> b[4:0] (logical)
// 4'b0111 - SRA   : result = a >>> b[4:0] (arithmetic)
// 4'b1000 - SLT   : result = (a < b) ? 1 : 0 (signed)
// 4'b1001 - SLTU  : result = (a < b) ? 1 : 0 (unsigned)
// 4'b1010 - SEQ   : result = (a == b) ? 1 : 0
// 4'b1011 - SNE   : result = (a != b) ? 1 : 0
// 4'b1100 - SGE   : result = (a >= b) ? 1 : 0 (signed)
// 4'b1101 - SGEU  : result = (a >= b) ? 1 : 0 (unsigned)
// ========================================================================

module alu #(parameter XLEN = 32, DLEN = $clog2(XLEN)) (
  input logic [XLEN-1 : 0] a,
  input logic [XLEN-1 : 0] b,
  input logic [3 : 0] alu_op,
  
  output logic [XLEN-1 : 0] result,
  output logic zero,
  output logic negative
);

  logic [XLEN-1 : 0] alu_result;
  
  always_comb begin
    
	case(alu_op)
	
	  4'b0000: alu_result = a + b;
	  4'b0001: alu_result = a - b;
	  
	  4'b0010: alu_result = a & b;
	  4'b0011: alu_result = a | b;
	  4'b0100: alu_result = a ^ b;

	  4'b0101: alu_result = a << b[DLEN-1:0];
	  4'b0110: alu_result = a >> b[DLEN-1:0];
	  4'b0111: alu_result = $signed(a) >>> b[DLEN-1:0];
	  
	  4'b1000: alu_result = ( $signed(a) < $signed(b) ) ? 32'b1 : 32'b0;
	  4'b1001: alu_result = ( a < b )  ? 32'b1 : 32'b0;
	  4'b1010: alu_result = ( a == b ) ? 32'b1 : 32'b0;
	  4'b1011: alu_result = ( a != b )? 32'b1 : 32'b0;
	  4'b1100: alu_result = ( $signed(a) >= $signed(b) ) ? 32'b1 : 32'b0;
	  4'b1101: alu_result = ( a >= b )  ? 32'b1 : 32'b0;
	  
	  default: alu_result = 32'b0;
	
	endcase
  
  end

  assign result = alu_result;
  assign zero = (alu_result == 32'b0);
  assign negative = alu_result[31];



endmodule
