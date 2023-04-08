`timescale 1ns / 1ps
module shiftRegister
(
input clk, 
input rst, 
input in, 
input shftEnable, 
output reg [7:0]out = 8'b00000000
);

	always@(posedge clk, posedge rst)
	begin
		if(rst == 1'b1)
			out <= 0;
		else
		begin
			if(shftEnable == 1'b1)
				out <= {in, out[7:1]};
			
			else
				out <= out;
		end
	
	end
	
endmodule