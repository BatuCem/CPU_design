(* blackbox *)
module Control (        //FSM Controller for Multicycle CPU
						input clk,    //clock signal
						input reset,  //reset signal
						input aludone,//operation done signal
						input [5:0] Opcode,//OPCODE from instruction
						input [5:0] AluFunc,//ALUFUNCT from instruction
						output reg MemtoRegSel,//Mem to Reg MUX sel
						output reg MemWriteEn, //Mem WR Enable
						output reg BranchEn,  //Branch En (cond.)
						output reg [4:0] AluOp,//ALU OPCODE
						output reg ALUASrcSel, //ALU A Source Sel
						output reg [1:0] ALUBSrcSel,//ALU B Source Sel
						output reg RegDstSel, //Reg Destination Sel
						output reg RegWriteEn,//Reg Write En
						output reg PCSrcSel,  //program counter source sel
						output reg PCWrite,   //PC write signal
						output reg IorDSel,   //address from ALU or PC Reg
						output reg IRWriteEn  //Instruction Write En
                 );

      endmodule

