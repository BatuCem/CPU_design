module alu #(parameter BIT_WIDTH = 32)
(		
        input clk,  //clock signal
		input reset,//reset signal
		input  [BIT_WIDTH-1:0] AluA,  //source A of ALU
		input  [BIT_WIDTH-1:0] AluB,  //source B of ALU 		
		input  [4:0] alucontrol,  //ALU control signal
		output reg aludone,   //ALU done signal for controller (division emphasize)
  output reg [BIT_WIDTH-1:0] result //result of ALU operation
		);
  
  //Divider declare and instantiate
  wire [BIT_WIDTH-1:0] divresult,divremainder;
  reg startdiv;
  wire divdone,divactive;
  divider div (clk,reset,startdiv,AluA,AluB,divresult,divremainder,divdone,divactive);
  //-----------------------------------------------------------------------------------
   always @(*)
  begin
		case(alucontrol)
		//ARITHMETIC-----------------------------------
		5'b00000: begin //ADD
			result=AluA+AluB;
			aludone=1'b1;
			startdiv=0;
		end
		5'b00001: begin //SUB
			result=AluA-AluB;
			aludone=1'b1;
			startdiv=0;
		end
		5'b00010: begin //MUL
			result=AluA*AluB;
			aludone=1'b1;
			startdiv=0;
		end
		5'b00011: begin //DIV
			if(divdone & ~divactive)//division done inferred
			begin
			 startdiv=0; //stop dividing
			 result=divresult;// take in quotient result
			 aludone=1'b1;   //set done signal
			end else
			begin
			 result=divresult;
			 startdiv=1; //start running division
			 aludone=0;  //pull done signal low
			end
		end
		5'b00100: begin //RMOD
			if(divdone & ~divactive)//division done inferred
			begin
			 startdiv=0; //stop dividing
			 result=divremainder;// take in remainder result
			 aludone=1'b1;   //set done signal
			end else
			begin
			 result=divremainder;
			 startdiv=1; //start running division
			 aludone=0;  //pull done signal low
			end
		end
		//LOGICAL-------------------------------
		5'b00101: begin	//AND
			result=AluA & AluB;
			aludone=1'b1;
			startdiv=0;
		end
		5'b00110: begin	//OR
			result=AluA | AluB;
			aludone=1'b1;
			startdiv=0;
		end
		5'b00111: begin	//NAND
			result=~(AluA & AluB);
			aludone=1'b1;
			startdiv=0;
		end
		5'b01000: begin	//NOR
			result=~(AluA | AluB);
			aludone=1'b1;
			startdiv=0;
		end
		5'b01001: begin	//XOR
			result=AluA ^ AluB;
			aludone=1'b1;
			startdiv=0;
		end
		5'b01010: begin //XNOR
			result=AluA ~^ AluB;
			aludone=1'b1;
			startdiv=0;
		end
		5'b01011: begin	//SHL
			result=AluA << AluB;
			aludone=1'b1;
			startdiv=0;
		end
		5'b01100: begin	//SHR
			result=AluA >> AluB;
			aludone=1'b1;
			startdiv=0;
		end
		5'b01101: begin	//ROL
			result=AluA <<(AluA << AluB) |  (AluA>>(BIT_WIDTH-AluB));
			aludone=1'b1;
			startdiv=0;
		end
		5'b01110: begin	//ROR
			result=AluA <<(AluA >> AluB) |  (AluA<<(BIT_WIDTH-AluB));
			aludone=1'b1;
			startdiv=0;
		end
		//COMPARATORS-----------------------------------------------
		5'b10101: begin //EQ
			if(AluA==AluB) result=32'd1;
			else result=32'd0;
			aludone=1'b1;
			startdiv=0;
		end
		5'b10000: begin	//LEQ
			if(AluA<=AluB) result=32'd1;
			else result=32'd0;
			aludone=1'b1;
			startdiv=0;
		end
		5'b10001: begin	//GEQ
			if(AluA>=AluB) result=32'd1;
			else result=32'd0;
			aludone=1'b1;
			startdiv=0;
		end
		5'b10010: begin	//G
			if(AluA>AluB) result=32'd1;
			else result=32'd0;
			aludone=1'b1;
			startdiv=0;
		end
		5'b10011: begin	//L
			if(AluA<AluB) result=32'd1;
			else result=32'd0;
			aludone=1'b1;
			startdiv=0;
		end
		5'b10100: begin	//NEQ
			if(AluA!=AluB) result=32'd1;
			else result=32'd0;
			aludone=1'b1;
			startdiv=0;
		end
		//OTHERS-----------------------
		default: begin
			result=0;
			aludone=0;
			startdiv=0;
		end
		endcase
	end
endmodule