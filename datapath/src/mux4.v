module mux4 #(parameter WIDTH =32)  //4-to-1 MUX Design
(input [WIDTH-1:0] d0, d1,d2,d3,    //4 data inputs
input [1:0] sel,                    //selection pin
output [WIDTH-1:0] y);              //selected output
//00: d0, 01: d1, 10:d2, 11:d3
assign y = sel[1] ? (sel[0] ? d3: d2) : (sel[0] ? d1 : d0);
endmodule
