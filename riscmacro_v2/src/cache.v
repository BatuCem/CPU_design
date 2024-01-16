(* blackbox *)
module cache #(parameter BIT_WIDTH = 32) //Memory Module
                 (input  clk,   //clock signal
                  input  memwrite,  //write enable signal
                  input  [BIT_WIDTH-1:0] addr, //RW address
                  input  [BIT_WIDTH-1:0] writedata, //W data
                  output [BIT_WIDTH-1:0] memdata);  //R data

endmodule