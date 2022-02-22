/*                  ALU Control                    */
module alu_ctrl(
  input logic [2:0] aluOp,
  input logic [2:0] func3,
  input logic func7,
  output logic [3:0] result);
  
  logic [6:0] alu_ctrl_in;
 
  assign alu_ctrl_in = {aluOp,func3,func7}; //concatenation
  
  always @(alu_ctrl_in) begin
 casez (alu_ctrl_in)
   7'b0000000: result=4'b0000; //add
   7'b0010000: result=4'b0000; //addi
   7'b0010001: result=4'b0000; //addi
   7'b0000001: result=4'b0001; //sub
   7'b0001110: result=4'b0100; //and
   7'b0011110: result=4'b0010; //andi
   7'b0011111: result=4'b0010; //andi
   7'b0000110: result=4'b0011; //or
   7'b0010110: result=4'b0011; //ori
   7'b0010111: result=4'b0011; //ori
   7'b0000010: result=4'b0100; //xor
   7'b0010010: result=4'b0100; //xori
   7'b0010011: result=4'b0100; //xori
   7'b0001000: result=4'b0101; //sll
   7'b0011000: result=4'b0101; //slli
   7'b0001010: result=4'b0110; //srl
   7'b0011010: result=4'b0110; //srli
   7'b0000100: result=4'b0111; //slt
   7'b0010100: result=4'b0111; //slti
   7'b0010101: result=4'b0111; //slti
   7'b0001100: result=4'b1000; //sltu
   7'b0011100: result=4'b1000; //sltiu
   7'b0011101: result=4'b1000; //sltiu
   7'b0001011: result=4'b1001; //sra
   7'b0011011: result=4'b1001; //srai
   7'b0100100: result=4'b0000; //lw
   7'b0100101: result=4'b0000; //lw
   7'b0110100: result=4'b0000; //sw
   7'b0110101: result=4'b0000; //sw
   7'b110???0: result=4'b0000; //auipc
   7'b110???1: result=4'b0000; //auipc
   7'b101???0: result=4'b0000; //lui
   7'b101???1: result=4'b0000; //lui
   7'b111???0: result=4'b1111; //jal
   7'b111???1: result=4'b1111; //jal
   7'b100???0: result=4'b1111; //jalr
   7'b100???1: result=4'b1111; //jalr
  default: result=4'b0000;
 endcase
end
endmodule
