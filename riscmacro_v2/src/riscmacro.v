module riscmacro #( parameter BIT_WIDTH=32)( //top module CPU with connections
    input clk,  //clock pin
    input reset,//reset pin
    input override_memwrite,
    input override_memread,
    input [BIT_WIDTH-1:0] override_rwdata,
    input [BIT_WIDTH-1:0] override_rwaddr,
    output [BIT_WIDTH-1:0] memdata// output for proper synthesis on all platforms and memory output
);

//Signal Declarations
wire [BIT_WIDTH-1:0] reg_instr,regfile_readA,regfile_readB,mem_Wdata;
wire [BIT_WIDTH-1:0] SrcB,SrcA,AluResult,addr_mem,reg_writedata,instruction;
wire [5:0] ctrl_Op,ctrl_Funct;
assign ctrl_Op=reg_instr[31:26];    //instruction sharing for OPCODE
assign ctrl_Funct=reg_instr[5:0];   //instruction sharing for ALUFUNCT
wire [4:0] reg_writeaddr,regA1,regA2,regA3;
assign regA1=reg_instr[25:21];      //instruction sharing for A1 read
assign regA2=reg_instr[20:16];      //instruction sharing for A2 read/write
assign regA3=reg_instr[15:11];      //instruction sharing for A3 write
wire MemtoRegSel,MemWriteEn,BranchEn,ALUASrcSel,RegDstSel,RegWriteEn,PCSrcSel,PCWrite,IorDSel,IRWriteEn,PCEn,aludone;
wire [4:0] AluOp;
wire [1:0] ALUBSrcSel;
assign memdata = reg_instr;
wire cacheWriteEn;
assign cacheWriteEn=MemWriteEn | override_memwrite;  //condition to overwrite memory block


//// instr sharing done as follows->> 
//                  31:26: Opcode
//                  25:21 reg addr 1
//                  20:16 reg addr 2
//                  15:0 immediate data
//                  15:11 reg write addr
//                  10:5 empty
//                  4:0 alufunct
assign PCEn = PCWrite | (BranchEn & AluResult[0]); //enable for PC iteration / conditional branching


//controller instantiation
Control controller (clk,reset,aludone,ctrl_Op,ctrl_Funct,MemtoRegSel,MemWriteEn,BranchEn,AluOp,ALUASrcSel,ALUBSrcSel,RegDstSel,RegWriteEn,PCSrcSel,PCWrite,IorDSel,IRWriteEn);

//instantiate registers
registerFile	regfile (clk,RegWriteEn,regA1,regA2,reg_writeaddr,reg_writedata,regfile_readA,regfile_readB);
alu 	alu (clk,reset, SrcA,SrcB,AluOp,aludone,AluResult);    //inst. ALU
cache meminst(clk,cacheWriteEn,addr_mem,mem_Wdata,instruction);   //instantiate cache memory
datapath dataregmuxinst(clk,reset,reg_instr,mem_Wdata,SrcB,SrcA,addr_mem,reg_writedata,regfile_readA,regfile_readB,AluResult,instruction,override_rwdata,override_rwaddr,reg_writeaddr,regA2,regA3,MemtoRegSel,ALUASrcSel,RegDstSel,PCSrcSel,IorDSel,IRWriteEn,PCEn,override_memwrite,override_memread,ALUBSrcSel);
endmodule
