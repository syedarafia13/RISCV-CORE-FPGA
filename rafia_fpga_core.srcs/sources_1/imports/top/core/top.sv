/////////////////////////////////////////////////////
/*                     Top Design                  */
/////////////////////////////////////////////////////
module top(
           input logic reset,
           input logic clk,
           output logic [3:0]main_o
           );
/////////////////////////////////////////////////////
/*            Add clock for FPGA                   */
/////////////////////////////////////////////////////
    logic clk;         
           clk_wiz_0  clk_wiz
            (
             // Clock out ports
             .clk_out1(clk),
             // Status and control signals
             .reset(!reset),
            // Clock in ports
             .clk_in1(clock),
             .locked()
            );                                       
  
  parameter width=32;
  /* verilator lint_off UNUSED */logic [31:0] output1;
  logic [31:0] pc_reg=32'b0;
  logic [31:0] inst;
  logic [31:0] pc_4;
  assign pc_4 = pc_reg+4;
  reg [2:0] pc_sel;
  logic [1:0] operand_A;
  logic operand_B;
  logic Y_sel;
  logic [31:0] Din;
  assign Din=32'd0;
  logic reg_write;
  logic enable=reset;
  logic branch;
  logic store;
  logic load;
  logic [31:0] read_data1;
  logic [31:0] read_data2;  
  logic [1:0] imm_sel;
  logic [31:0] SB_Type1;
  logic [31:0] SB_Type2;
  logic [31:0] jal;
  logic [31:0] imm;
  logic [2:0] alu_op;                         
  logic [31:0] zeros=32'd0;
  logic [31:0] mux_out_1;
  logic [31:0] mux_out_2;       
  logic [3:0] alu_control;
  logic [31:0] out; 
  logic [31:0] data_wb;
  logic func_7;
  assign func_7=inst[30];        
  logic branch_out;       
  logic [width-1:0] mem_read_data;
  
  assign main_o = output1[3:0];
  
  assign mux_out_1 = operand_A == 2'b00 ? read_data1:(operand_A == 2'b01 ? pc_4:(operand_A == 2'b10 ? pc_reg : zeros));   // logic for ALU_Muxes1
  assign mux_out_2 = operand_B == 0 ? read_data2 : imm;    // logic for ALU_Muxes2
  assign data_wb = (load == 0) ? out : mem_read_data;      // logic for Data_Memory_Mux
  assign SB_Type2 = (Y_sel == 0) ? pc_4 : SB_Type1;        // logic for Branch_Mux
  assign Y_sel = branch & branch_out;                      // logic for Branch and_gate 
  
////////////////////////////////////////////////////////
/*                Program Counter                     */
////////////////////////////////////////////////////////
always @(posedge clk) begin
  if(reset) begin
    case (pc_sel)
     3'b00 : begin
       pc_reg <= pc_reg+4;             // PC+4
     end
     3'b01 : begin
       pc_reg <= read_data1+imm;       // Jalr
     end
      3'b10 : begin
        pc_reg <= jal;                // UJ
     end
      3'b11 : begin
        pc_reg <= SB_Type2;            // Branches
     end
     default :pc_reg <= 32'b0;
   endcase  
  end
  else pc_reg <= 32'b0;
end

/*                   Calling Modules                */

//////////////////////////////////////////////////////
/*                 Instruction Memory               */
//////////////////////////////////////////////////////
  instr_mem i_mem(
                .clock(clk),
                .reset(reset),
                .writeEnable(1'b0),
                .readEnable(enable),
                .readAddress(pc_reg[13:2]),
                .writeAddress(12'b0),
                .writeData(Din),
                .readData(inst)
                ); 
  
////////////////////////////////////////////////////////
/*                    Control Unit                    */
////////////////////////////////////////////////////////
  ctrl_unit cu(.opcode(inst[6:0]),
                  .reg_write(reg_write),
                  .branch(branch),
                  .store(store),
                  .load(load),
                  .op_a(operand_A),
                  .op_b(operand_B),
                  .imm_sel(imm_sel),
                  .pc_sel(pc_sel),
                  .alu_op(alu_op) 
                  );

////////////////////////////////////////////////////////
/*                   Register File                    */
////////////////////////////////////////////////////////
  reg_file rf(.clk(clk),
               .write_enable(reg_write),
               .rs1(inst[19:15]),
               .rs2(inst[24:20]),
               .rd(inst[11:7]),
               .write_data(data_wb),
               .readdata1(read_data1),
               .readdata2(read_data2),
               .out(output1)
               );

////////////////////////////////////////////////////////
/*                  Immediate Generation              */
////////////////////////////////////////////////////////
 imm_gen ig(.instr(inst[31:7]),
            .pc(pc_reg),
            .imm_sel(imm_sel),
            .SB_Type(SB_Type1),
            .UJ_Type(jal),
            .imm(imm)
            );   

////////////////////////////////////////////////////////
/*                     ALU Control                    */        
////////////////////////////////////////////////////////          
  alu_ctrl alu_ctrl(.aluOp(alu_op),
                      .func3(inst[14:12]),
                      .func7(func_7),
                      .result(alu_control)
                      );

////////////////////////////////////////////////////////
/*                        ALU                         */
////////////////////////////////////////////////////////                            
  alu alu(.input_a(mux_out_1),
           .input_b(mux_out_2),
           .alu_control(alu_control),
           .out(out)
           );

////////////////////////////////////////////////////////
/*                     Data Memory                    */
////////////////////////////////////////////////////////
  data_mem d_mem(.clk(clk),
                 .wen(store),
                 .ren(load),
                 .add(out[13:2]),
                 .datain(read_data2),
                 .dataout(mem_read_data)
                 );

////////////////////////////////////////////////////////
/*                      Branches                      */  
////////////////////////////////////////////////////////        
  branches branches(.input_a(read_data1),
                    .input_b(read_data2),
                    .func3(inst[14:12]),
                    .branch_out(branch_out)
                    );
endmodule
