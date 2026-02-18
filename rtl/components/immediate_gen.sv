// ========================================================================
// Module: immediate_gen.sv
// Description: Immediate Generator for RISC-V RV32I (ID Stage)
// Author: Padmanabha Nikhil
// ========================================================================

module immediate_gen #(parameter XLEN = 32)(
  input logic [XLEN-1 : 0] instruction,
  input logic [2:0] imm_type,
  output logic [XLEN-1 : 0] immediate
);

  always_comb begin
    case(imm_type)
	  // I-Type
	  3'b000: immediate = { {20{instruction[31]}}, instruction[31:20] };
	  
	  // S-Type
	  3'b001: immediate = { {20{instruction[31]}}, instruction[31:25], instruction[11:7] };
	  
	  // B-Type
	  3'b010: immediate = { {19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0 };
	  
	  // U-Type
	  3'b011: immediate = { instruction[31:12], 12'b0 };
	  
	  // J-Type
	  3'b100: immediate = { {11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0 };
	  
	  default: immediate = XLEN'b0;
	endcase
  end



endmodule