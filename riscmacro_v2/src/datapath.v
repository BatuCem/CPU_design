module datapath #( parameter BIT_WIDTH=32)( //top module CPU with connections
    input clk,  //clock pin
    input reset,//reset print
    output [BIT_WIDTH-1:0] reg_instr,mem_Wdata,SrcB,SrcA,addr_mem,reg_writedata,
    input [BIT_WIDTH-1:0] regfile_readA,regfile_readB,AluResult,instruction,override_rwdata,override_rwaddr,
    output [4:0] reg_writeaddr,
    input [4:0] regA2,regA3,
    input MemtoRegSel,ALUASrcSel,RegDstSel,PCSrcSel,IorDSel,IRWriteEn,PCEn,override_memwrite,override_memread,
    input [1:0] ALUBSrcSel
);

endmodule
