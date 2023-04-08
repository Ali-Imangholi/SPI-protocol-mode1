module sampler(
input clk,
input rst,
input MOSI,
input chipSelect,
output reg sample
);

// sampling on negedge
always@(negedge clk, negedge ~rst)
begin: sampler
	if(rst == 1'b1)
		sample <= 1'bZ;
	else if(chipSelect == 1'b0)
		sample <= MOSI;
	else
		sample <= 1'bZ;
end

endmodule