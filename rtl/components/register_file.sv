// ========================================================================
// Module: register_file.sv
// Description: Register Files for RISC-V RV32I (ID Stage)
// Author: Padmanabha Nikhil
// ========================================================================

module register_file #(parameter XLEN = 32)(
  input logic clk,
  input logic rst_n,
  
  input logic [4:0] rs1_addr,
  output logic [XLEN-1 : 0] rs1_data,
  
  input logic [4:0] rs2_addr,
  output logic [XLEN-1 : 0] rs2_data,
  
  input logic wr_en,
  input logic [4:0] rd_addr,
  input logic [XLEN-1 : 0] rd_data
);


  logic [XLEN-1 : 0] registers [0:31];
  
  // Asynchronous reads
  assign rs1_data = ( rs1_addr == 5'b0) ? {XLEN{1'b0}} : registers[rs1_addr];
  assign rs2_data = ( rs2_addr == 5'b0) ? {XLEN{1'b0}} : registers[rs2_addr];
  
  // Register Write
  always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) registers <= '{default: '0};
	else begin
	  if (wr_en && rd_addr != 5'b0) registers[rd_addr] <= rd_data;
	end
  end

endmodule