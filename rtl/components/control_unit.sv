// ========================================================================
// Module: control_unit.sv
// Description: Immediate Generator for RISC-V RV32I (ID Stage)
// Author: Padmanabha Nikhil
// ========================================================================


// ================================================================================================================
// | op_code | inst | alu_src | alu_op | mem_read | mem_write | reg_write | mem_to_reg | branch | jump | imm_type |
// | 0110011 |R-Type|    0    |   10   |     0    |     0     |     1     |      0     |    0   |   0  |  xxx (R) |
// | 0010011 |I-Type|    1    |   10   |     0    |     0     |     1     |      0     |    0   |   0  |  000 (I) |
// | 0000011 | Load |    1    |   00   |     1    |     0     |     1     |      1     |    0   |   0  |  000 (I) |
// | 0100011 |Store |    1    |   00   |     0    |     1     |     0     |      x     |    0   |   0  |  001 (S) |
// | 1100011 |Branch|    0    |   01   |     0    |     0     |     0     |      x     |    1   |   0  |  010 (B) |
// | 1101111 | JAL  |    x    |   00   |     0    |     0     |     1     |      0     |    0   |   1  |  100 (J) |
// | 1100111 | JALR |    1    |   00   |     0    |     0     |     1     |      0     |    0   |   1  |  000 (I) |
// | 0110111 | LUI  |    1    |   00   |     0    |     0     |     1     |      0     |    0   |   0  |  011 (U) |
// | 0010111 |AUIPC |    1    |   00   |     0    |     0     |     1     |      0     |    0   |   0  |  011 (U) |
// ================================================================================================================

module control_unit(
  input logic [6:0] op_code,
  
  output logic alu_src,
  output logic [1:0] alu_op,
  
  output logic mem_read,
  output logic mem_write,
  
  output logic reg_write,
  output logic mem_to_reg,
  
  output logic branch,
  output logic jump,
  
  output logic [2:0] imm_type
);


  always_comb begin
  
    case (op_code)
	  
	  // R-Type
	  7'b0110011:begin
	    alu_src = 1'b0;
		alu_op = 2'b10;
		mem_read = 1'b0;
		mem_write = 1'b0;
		reg_write = 1'b1;
		mem_to_reg = 1'b0;
		branch = 1'b0;
		jump = 1'b0;
		imm_type = 3'b111;	// R-Type xxx - No immediate
	  end
	  
	  // I-Type
	  7'b0010011:begin
	    alu_src = 1'b1;
		alu_op = 2'b10;
		mem_read = 1'b0;
		mem_write = 1'b0;
		reg_write = 1'b1;
		mem_to_reg = 1'b0;
		branch = 1'b0;
		jump = 1'b0;
		imm_type = 3'b000;	// I-Type
	  end
	  
	  // Load
	  7'b0000011:begin
	    alu_src = 1'b1;
		alu_op = 2'b00;
		mem_read = 1'b1;
		mem_write = 1'b0;
		reg_write = 1'b1;
		mem_to_reg = 1'b1;
		branch = 1'b0;
		jump = 1'b0;
		imm_type = 3'b000;	// I-Type
	  end
	  
	  // Store
	  7'b0100011:begin
	    alu_src = 1'b1;
		alu_op = 2'b00;
		mem_read = 1'b0;
		mem_write = 1'b1;
		reg_write = 1'b0;
		mem_to_reg = 1'b1;	// x
		branch = 1'b0;
		jump = 1'b0;
		imm_type = 3'b001;	// S-Type
	  end
	  
	  // Branch
	  7'b1100011:begin
	    alu_src = 1'b0;
		alu_op = 2'b01;
		mem_read = 1'b0;
		mem_write = 1'b0;
		reg_write = 1'b0;
		mem_to_reg = 1'b1;	// x
		branch = 1'b1;
		jump = 1'b0;
		imm_type = 3'b010;	// B-Type
	  end
	  
	  // JAL
	  7'b1101111:begin
	    alu_src = 1'b1;		// x
		alu_op = 2'b00;
		mem_read = 1'b0;
		mem_write = 1'b0;
		reg_write = 1'b1;
		mem_to_reg = 1'b0;
		branch = 1'b0;
		jump = 1'b1;
		imm_type = 3'b100;	// J_Type
	  end
	  
	  // JALR
	  7'b1100111:begin
	    alu_src = 1'b1;
		alu_op = 2'b00;
		mem_read = 1'b0;
		mem_write = 1'b0;
		reg_write = 1'b1;
		mem_to_reg = 1'b0;
		branch = 1'b0;
		jump = 1'b1;
		imm_type = 3'b000;	// I-Type
	  end
	  
	  // LUI
	  7'b0110111:begin
	    alu_src = 1'b1;
		alu_op = 2'b00;
		mem_read = 1'b0;
		mem_write = 1'b0;
		reg_write = 1'b1;
		mem_to_reg = 1'b0;
		branch = 1'b0;
		jump = 1'b0;
		imm_type = 3'b011;	// U-Type
	  end
	  
	  // AUIPC
	  7'b0010111:begin
	    alu_src = 1'b1;
		alu_op = 2'b00;
		mem_read = 1'b0;
		mem_write = 1'b0;
		reg_write = 1'b1;
		mem_to_reg = 1'b0;
		branch = 1'b0;
		jump = 1'b0;
		imm_type = 3'b011;	// U-Type
	  end
	  
	  // default
	  default:begin
	    alu_src = 1'b0;
		alu_op = 2'b00;
		mem_read = 1'b0;
		mem_write = 1'b0;
		reg_write = 1'b0;
		mem_to_reg = 1'b0;
		branch = 1'b0;
		jump = 1'b0;
		imm_type = 3'b000;
	  end
	endcase
  
  end


endmodule