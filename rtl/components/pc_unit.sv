// ========================================================================
// Module: pc_unit.sv
// Description: Program Counter for RISC-V RV32I (EX Stage)
// Author: Padmanabha Nikhil
// ========================================================================

// ========================================================================
// alu_src = 00 => pc = pc_4
// alu_src = 01 => pc = branch_target
// alu_src = 10 => pc = jump_target

// pc is updated only when pc_write is high
// ========================================================================



module pc_unit #(
  parameter XLEN = 32
)(
  input logic clk,
  input logic rst_n,
  
  input logic pc_write,
  input logic [1:0] pc_src,
  
  input logic [XLEN-1 : 0] pc_4,
  input logic [XLEN-1 : 0] branch_target,
  input logic [XLEN-1 : 0] jump_target,
  
  output logic [XLEN-1 : 0] pc
);

  reg [XLEN-1 : 0] pc_next;
  
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) pc <= {XLEN{1'b0}};
	else if (pc_write) pc <= pc_next;
	// else pc is same
  end
  
  always_comb begin
    case (pc_src)
	  2'b00: pc_next = pc_4;
	  2'b01: pc_next = branch_target;
	  2'b10: pc_next = jump_target;
	  default: pc_next = pc_4;
	endcase
  end

endmodule