module cache #(parameter BIT_WIDTH = 32) //Memory Module
                 (input  clk,   //clock signal
                  input  memwrite,  //write enable signal
                  input  [BIT_WIDTH-1:0] addr, //RW address
                  input  [BIT_WIDTH-1:0] writedata, //W data
                  output [BIT_WIDTH-1:0] memdata);  //R data

  reg [31:0]      mem [2**(32)-1:0];  
  initial
  begin
    $readmemh("./memfile.dat", mem);   //init memory array from directory (HEX)
end

  // read and write bytes from 32-bit word
  always @(posedge clk)
    begin
    if(memwrite) mem[addr]   <= writedata;  //write data
    end 
    

   assign memdata = mem[addr];  //read data
endmodule