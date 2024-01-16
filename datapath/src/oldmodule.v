module datapathold #( parameter BIT_WIDTH=32)( //top module CPU with connections
    input clk,  //clock pin
    input reset,//reset print
    output [BIT_WIDTH-1:0] reg_instr,reg_readB,SrcB,SrcA,addr_mem,reg_writedata,
    input [BIT_WIDTH-1:0] regfile_readA,regfile_readB,AluResult,instruction,
    output [4:0] reg_writeaddr,
    input [4:0] regA2,regA3,
    input MemtoRegSel,ALUASrcSel,RegDstSel,PCSrcSel,IorDSel,IRWriteEn,PCEn,
    input [1:0] ALUBSrcSel
);

wire [BIT_WIDTH-1:0] reg_instr_in,reg_data_in,reg_readA_in,reg_readB_in,signimm,AluOut,pcnext,pc;


assign reg_instr=reg_instr_in;
assign reg_readB=reg_readB_in;



flopResEn	instreg (clk,reset,IRWriteEn,instruction, reg_instr_in); //instruction register

flopResEn 	datareg (clk,reset,1'b1,instruction,reg_data_in); //data register from instrucation
mux2   mux_writetoregfile(AluOut,reg_data_in,MemtoRegSel,reg_writedata);   //selection to write regs
mux2 #(5) 	mux_writeaddrsel(regA2,regA3,RegDstSel,reg_writeaddr);   //selection to write addr
signextend	signext (reg_instr_in[15:0],signimm);   //sign extend
flopResEn	readregA (clk,reset,1'b1,regfile_readA,reg_readA_in);//registered read registers
flopResEn	readregB (clk,reset,1'b1,regfile_readB,reg_readB_in);
mux4	alubmux (reg_readB_in,32'd1,signimm,32'd0,ALUBSrcSel,SrcB); //select source B of ALU
mux2 	aluamux (pc,reg_readA_in,ALUASrcSel,SrcA);   //select source A of ALU
flopResEn 	alureg (clk,reset,1'b1,AluResult,AluOut);    //register ALU result
mux2 	aluoutmux (AluResult,AluOut,PCSrcSel,pcnext); //alu output selection for PC
flopResEn 	pcreg (clk,reset,PCEn,pcnext,pc);    //register PC
mux2 	pcmux (pc,AluOut,IorDSel,addr_mem);   //select PC

endmodule

