module signextend(  //16-to-32 Sign Extension Module
input [15:0] a,     //input data
output [31:0] y);   //sign extended output

//Loads input itself right-justified,
//pads left with the same sign (MSB of input)
assign y = {{16{a[15]}}, a};
endmodule
