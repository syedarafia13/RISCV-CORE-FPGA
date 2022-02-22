/*              Data Memory                 */
module data_mem(
  input logic clk,
  input logic wen,
  input logic ren,
  input logic [11:0]  add,
  output logic [31:0] dataout,
  input logic [31:0] datain
);  
  reg [31:0] mem [4095:0];
  always @(posedge clk) begin
    if(wen==1) begin
      mem[add]<=datain;
    end
  end
  assign dataout= (ren==1)? mem[add]:32'b? ;
endmodule
