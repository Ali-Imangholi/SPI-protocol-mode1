`timescale 1ns / 1ps
module testbench;

//
reg tb_CLK, tb_RST;
//
wire tb_MOSI_dp;
wire tb_MISO_dp;
wire tb_MOSI_cu;
wire tb_MISO_cu;

assign tb_MOSI_dp = tb_MOSI_cu;
assign tb_MISO_cu = tb_MISO_dp;

wire [6:0] tb_RED_LED;
wire [6:0] tb_BLUE_LED;
wire tb_CHIPSELECT;
//make instant from top module (slave SPI)
slaveSPI topModuleSlave
(
.SCK(tb_CLK),
.RST(tb_RST),
.CHIPSELECT(tb_CHIPSELECT),
.MOSI(tb_MOSI_dp),
.MISO(tb_MISO_dp),
.RED_LED(tb_RED_LED),
.BLUE_LED(tb_BLUE_LED)
);

MasterModeling topModuleMaster
(
.clk(tb_CLK),
.rst(tb_RST),
.MISO(tb_MISO_cu),
.chipSelect(tb_CHIPSELECT),
.MOSI(tb_MOSI_cu)
);

// make clk
initial
begin
	tb_CLK = 1'b0;
end

always #10 tb_CLK = ~tb_CLK;

// make reset signal
initial
begin 
	tb_RST = 1'b0;   
	#15
	tb_RST = 1'b1;
	#15
	tb_RST = 1'b0;
	#15;
end

endmodule