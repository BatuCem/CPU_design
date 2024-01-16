(* blackbox *)
module registerFile #(parameter BIT_WIDTH=32, parameter ADDR_WIDTH=5) //32x32 register bank of the CPU
(
	input clk,
	input writeEn, //write enable
	input [ADDR_WIDTH-1:0] readAddr1,  //2 register read capabiity
	input [ADDR_WIDTH-1:0] readAddr2,
	input [ADDR_WIDTH-1:0] writeAddr,  //write register at address
	input [BIT_WIDTH-1:0] writeData,   //write data
	output [BIT_WIDTH-1:0] readData1,  //2 read data
	output [BIT_WIDTH-1:0] readData2   
);


endmodule

