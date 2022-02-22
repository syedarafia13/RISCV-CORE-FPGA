/*               Control Unit                         */
module ctrl_unit(
  input logic [6:0] opcode,
  output logic [2:0] alu_op,
  output logic reg_write,
  output logic branch,store,
  output logic load,
  output logic [1:0] op_a,
  output logic op_b,
  output logic [2:0] pc_sel,
  output logic [1:0] imm_sel
);
always_comb begin
      reg_write = 1'b0;
      branch = 1'b0;
      store = 1'b0;
      load = 1'b0;
      op_a = 2'b00;
      op_b = 1'b0;
      imm_sel = 2'b00;
      alu_op = 3'b00;
      pc_sel = 3'b111;
   case(opcode) 
      7'b0110011:  //R-Type
         begin
         reg_write = 1'b1;
         branch = 1'b0;
         store = 1'b0;
         load = 1'b0;
         op_a = 2'b00;
         op_b = 1'b0;
         imm_sel = 2'b00;
         pc_sel = 3'b00;
         alu_op = 3'b000;
        end

      7'b0010011: //I-Type
        begin 
         reg_write = 1'b1;
         branch = 1'b0;
         store = 1'b0;
         load = 1'b0;
         op_a = 2'b00;
         op_b = 1'b1;
         imm_sel = 2'b10;
         pc_sel = 3'b00;
         alu_op = 3'b001;
        end

      7'b0000011: //Load
         begin
         reg_write = 1'b1;
         branch = 1'b0;
         store = 1'b0;
         load = 1'b1;
         op_a = 2'b00;
         op_b = 1'b1;
         imm_sel = 2'b10;
         pc_sel = 3'b00;
         alu_op = 3'b010;
         end

      7'b1100111: // Jalr
         begin
         reg_write = 1'b1;
         branch = 1'b0;
         store = 1'b0;
         load = 1'b0;
         op_a = 2'b01;
         op_b = 1'b0;
         imm_sel = 2'b10;
         pc_sel = 3'b01;
         alu_op = 3'b100;
         end

      7'b0100011: // Store
         begin
         reg_write = 1'b0;
         branch = 1'b0;
         store = 1'b1;
         load = 1'b0;
         op_a = 2'b00;
         op_b = 1'b1;
         imm_sel = 2'b00;
         pc_sel = 3'b00;
         alu_op = 3'b011;
         end

      7'b1100011: // Branch
         begin
         reg_write = 1'b0;
         branch = 1'b1;
         store = 1'b0;
         load = 1'b0;
         op_a = 2'b00;
         op_b = 1'b0;
         imm_sel = 2'b01;
         pc_sel = 3'b11;
         end

      7'b0010111:  // AUIPC
         begin
         reg_write = 1'b1;
         branch = 1'b0;
         store = 1'b0;
         load = 1'b0;
         op_a = 2'b10;
         op_b = 1'b1;
         imm_sel = 2'b01;
         pc_sel = 3'b00;
         alu_op = 3'b110;
         end

      7'b0110111:  // LUI
         begin
         reg_write = 1'b1;
         branch = 1'b0;
         store = 1'b0;
         load = 1'b0;
         op_a = 2'b11;
         op_b = 1'b0;
         imm_sel = 2'b00;
         pc_sel = 3'b00;
         alu_op = 3'b101;
         end

      7'b1101111:  // Jal
         begin
         reg_write = 1'b1;
         branch = 1'b0;
         store = 1'b0;
         load = 1'b0;
         op_a = 2'b01;
         op_b = 1'b0;
         imm_sel = 2'b00;
         pc_sel = 3'b10;
         alu_op = 3'b111;
         end
        default :begin 
         pc_sel = 3'b111;
         reg_write = 1'b0;
         branch = 1'b0;
         store = 1'b0;
         load = 1'b0;
         op_a = 2'b00;
         op_b = 1'b0;
         imm_sel = 2'b00;
         alu_op = 3'b000;
        end
      endcase
   end

endmodule
