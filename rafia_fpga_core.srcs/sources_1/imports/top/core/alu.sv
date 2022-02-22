/*                       ALU                       */
module alu(
 input logic [31:0] input_a,  
 input logic [31:0] input_b,  
 input logic [3:0] alu_control, 
 output logic [31:0] out
 );

 always_comb begin
 case(alu_control)
 4'b0000 : out = input_a + input_b;  //add
 4'b0001 : out = input_a - input_b;  //sub
 4'b0010 : out = input_a ^ input_b;  //xor
 4'b0011 : out = input_a | input_b;  //or
 4'b0100 : out = input_a & input_b;  //and
 4'b0101 : out = input_a << input_b; //sll
 4'b0110 : out = input_a >> input_b; //srl
 4'b0111 : out = (input_a < input_b) ? 32'd1 : 32'd0;
 4'b1000 : out = ($signed(input_a) < $signed(input_b)) ? 32'd1 : 32'd0;
 4'b1001 : out = input_a >>> input_b; //sra
 4'b1111 : out = input_a;
   
 default: out = input_a + input_b; 
 endcase
end
endmodule
