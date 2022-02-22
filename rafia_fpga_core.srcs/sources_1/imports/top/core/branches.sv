/*                   Branches                  */
module branches(
  input logic [31:0] input_a,
  input logic [31:0] input_b,
  input logic [2:0] func3,
  output logic branch_out
);
  always_comb begin
    branch_out = 0;
    case(func3)
      
      //beq
      3'b000 : 
        begin
        if(input_a == input_b)
          branch_out = 1;
        end
      
      //bne
      3'b001 : 
        begin
          if(input_a != input_b)
           branch_out = 1;
        end
      
      //blt
      3'b100 : 
        begin
        if(input_a < input_b)
           branch_out = 1;
        end
      
      //bge
      3'b101 : 
        begin
        if(input_a >= input_b)
           branch_out = 1;
        end
      
      //bltu
      3'b110 : 
        begin
          if ($unsigned(input_a) < $unsigned(input_b))
           branch_out = 1;
        end
      
      //bgeu
      3'b111 : 
        begin
          if ($unsigned(input_a) >= $unsigned(input_b))
           branch_out = 1;
        end
      
default: branch_out=0;
 endcase
end
endmodule
