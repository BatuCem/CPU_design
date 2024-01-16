module flopResEn #(parameter BIT_WIDTH = 32) //Register With Reset and Enable Pin Module
(input clk, reset,en,   //clock, reset, enable pins respectively
input [BIT_WIDTH-1:0] d,//input data
output reg [BIT_WIDTH-1:0] q);//registered output data
always @(posedge clk)
begin
if (reset) q <= 0; // if reset, set to 0
else if (en==1'b1) q <= d;  //if not reset and enabled, load input data
end
endmodule
