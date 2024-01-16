module mux2 #(parameter WIDTH = 32) //2-to-1 MUX Module
(input [WIDTH-1:0] d0, d1,//Data Input
input s,    //Select Pin
output [WIDTH-1:0] y);  //Selected Output
assign y = s ? d1 : d0; //if s is 1, take d1, else take d0
endmodule
