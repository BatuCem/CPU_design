(* blackbox *)
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
  
endmodule