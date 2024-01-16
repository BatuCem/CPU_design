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
		reg[3:0] CurState; //FSM States
		always @(posedge clk)
		begin
			if(reset)
              begin
                //reset condition
              	CurState<=4'd0;
                MemtoRegSel<=0;
				MemWriteEn<=0;
				BranchEn<=0;
				AluOp<=0;
				ALUASrcSel<=0;
				ALUBSrcSel<=0;
				RegDstSel<=0;
				RegWriteEn<=0;
				PCSrcSel<=0;
				PCWrite<=0;
				IorDSel<=0;
				IRWriteEn<=0;
              end
			else begin
			case(CurState)
				4'd0: begin
				    //Common 0 state for FETCH state
				    BranchEn<=0;
				    RegDstSel<=0;
				    MemWriteEn<=0;
					IorDSel<=0;
					ALUASrcSel<=0;
					ALUBSrcSel<=2'b01;
					AluOp<=0;
					PCSrcSel<=0;
					CurState<=4'd15; //->15th state for secure branching
					IRWriteEn<=1'b1;
					PCWrite<=1;
					RegWriteEn<=1'b0;
					MemtoRegSel<=0;
					end
				4'd1: begin
				    //DECODE ALU state
					ALUASrcSel<=1'b1;
					ALUBSrcSel<=2'b10;
					AluOp<=0;
					case(Opcode)
						6'b100010,6'b100011: CurState<=4'd2; //LW SW
						6'b000000: CurState<=4'd6;	//R-type
						6'b110000: CurState<=4'd9;	//conditional branch
						6'b100000: CurState<=4'd10; //ADDI
						default: CurState<=4'd0;		
					endcase
				end
				4'd2: begin
				    //LW/SW Adressing State
					ALUASrcSel<=1'b1;
					ALUBSrcSel<=2'b10;
					AluOp<=0;
					if(Opcode==6'b100011)
					begin
						CurState<=4'd5; //SW
					end else begin
						CurState<=4'd3; //LW
					end
				end
				4'd3: begin
				    //LW Memory Read state
					IorDSel<=1'b1;
					CurState<=4'd4;
				end
				4'd4: begin
				    //LW Memory Writeback to Reg State
					RegDstSel<=1'b0;
					MemtoRegSel<=1'b1;
					RegWriteEn<=1'b1;
					CurState<=4'd0;
				end
				4'd5: begin
				    //SW Memory Write form Reg state
					IorDSel<=1'b1;
					MemWriteEn<=1'b1;
					CurState<=4'd0;
				end
				4'd6: begin
				    //R-type Execute state
					ALUASrcSel<=1'b1;
					ALUBSrcSel<=2'b00;
					AluOp<=AluFunc[4:0];
					CurState<=4'd7;
				end
				4'd7: begin
				    //Wait For ALU done state
					if(aludone==1'b1) CurState<=4'd8;
				end
				4'd8: begin
				    //Write R-type result to Reg
					RegDstSel<=1'b1;
					MemtoRegSel<=1'b0;
					RegWriteEn<=1'b1;
					CurState<=4'd0;
				end
				4'd9: begin
				    //Branching if  comparison valid;
				    ALUASrcSel<=1'b1;
					ALUBSrcSel<=2'b00;
					AluOp<=5'b00;
					PCSrcSel<=1'b1;
					BranchEn<=1'b1;
					CurState<=4'd0;
				end
				4'd10: begin
				    //ADDI Execution State
				    ALUASrcSel<=1'b1;
					ALUBSrcSel<=2'b10;
					AluOp<=5'b00;
					CurState<=4'd11;
				end
				4'd11: begin
				    //ADDI Reg Write state
				    RegDstSel<=0;
				    MemtoRegSel<=0;
				    RegWriteEn<=1'b1;
				    CurState<=4'd0;
				end
                4'd15: begin
                    //Secure branching state
				    IRWriteEn<=1'b0;				    
					PCWrite<=1'b0;
					CurState<=4'd1;
                end
				default: begin
				    //Other invalid states
					CurState<=0;
				end
			endcase
			end
		end

      endmodule
