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

reg [BIT_WIDTH-1:0] registerf[BIT_WIDTH-1:0] ; //2D array register bank
assign readData1 = (readAddr1!=0) ? registerf[readAddr1] :0;    //read data at address
assign readData2 = (readAddr2!=0) ? registerf[readAddr2]	:0;    

integer i;
initial begin //initialize register bank as all zeros
    for (i = 0; i < BIT_WIDTH; i = i + 1) begin
        registerf[i] = {BIT_WIDTH{1'b0}};
    end
    end

always @(posedge clk)
begin
	if(writeEn)    //write data at address
	begin
		registerf[writeAddr] <=writeData;
	end
end
endmodule
