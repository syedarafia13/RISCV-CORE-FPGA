/*                 Register File                   */
module reg_file(
  input logic clk,
  input logic write_enable,
  input logic [4:0] rs1,
  input logic [4:0] rs2,
  input logic [4:0] rd,
  input logic [31:0] write_data,
  output logic [31:0] readdata1,
  output logic [31:0] readdata2,
  output logic [31:0] out
);
  
  logic [31:0] reg_array [0:31];
  
  always_ff @ (posedge clk) begin
    if (write_enable) begin
      out <= write_data;
      if(rd!=0)reg_array [rd] <= write_data;
       reg_array[0]<=32'd0;
    end
  end
  assign readdata1 = reg_array[rs1];
  assign readdata2 = reg_array[rs2];
endmodule
