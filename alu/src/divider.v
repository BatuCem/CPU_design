module divider(  
   input      clk,      //clock signal
   input      reset,    //reset
   input      start_division,   //division enable
   input [31:0]  dividend,        
  input [31:0]  divisor,  
  output [31:0]  quotient,
  output [31:0] remainder,  
   output reg division_done,   // =1 when ready to get the result
   output  division_active     //active signal
   );  
   reg       active;   // True if the divider is running  
   reg [4:0]    cycle;   // Number of cycles to go  
   reg [31:0]   result;   // Begin with dividend, end with quotient  
   reg [31:0]   denom;   // divisor
   reg [31:0]   work;    // shifting remainder
   // Calculate the current digit  
   wire [32:0]   sub = { work[30:0], result[31] } - denom;  //shifter
   // Send the results to our master  
  assign division_active = active;
   assign quotient = result;
   assign remainder = work;
   // The state machine  
   always @(posedge clk) begin  
     if (reset) begin  
       active <= 0; 
       division_done<=0;
       cycle <= 0;  
       result <= 0;  
       denom <= 0;  
       work <= 0;  
     end  
     else if(start_division) begin  
       if (active) begin  
         // Run an iteration of the divide.  
         if (sub[32] == 0) begin  
           work <= sub[31:0];  
           result <= {result[30:0], 1'b1};  
         end  
         else begin  
           work <= {work[30:0], result[31]};  
           result <= {result[30:0], 1'b0};  
         end  
         if (cycle == 0) begin  
           active <= 0;
           division_done<=1;
         end else division_done<=0;
         cycle <= cycle - 5'd1;  
         
       end  
       else begin  
         // Set up for an unsigned divide.  
         cycle <= 5'd31;  
         result <= dividend;  
         denom <= divisor;  
         work <= 32'b0;  
         active <= 1;  
       end  
     end else division_done<=0;
   end  
 endmodule