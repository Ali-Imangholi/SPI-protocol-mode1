`timescale 1ns / 1ps
module slaveSPI
(
input SCK,
input RST,
input CHIPSELECT,
input MOSI,
output MISO,
output [6:0]RED_LED,
output [6:0]BLUE_LED
);


wire dp_SHFTENABLE_1;
wire dp_SHFTENABLE_2;
wire dp_MUX_SELECT;

wire cu_SHFTENABLE_1;
wire cu_SHFTENABLE_2;
wire cu_MUX_SELECT;

wire dp_CU_2_DP_RST;
wire cu_CU_2_DP_RST;


wire cu_SAMPLE;
wire dp_SAMPLE;



wire cu_RED_LED_ENB;
wire cu_BLUE_LED_ENB;

wire dp_RED_LED_ENB;
wire dp_BLUE_LED_ENB;


assign dp_RED_LED_ENB = cu_RED_LED_ENB;
assign dp_BLUE_LED_ENB = cu_BLUE_LED_ENB;



assign CLK = SCK & (~CHIPSELECT);
assign dp_CU_2_DP_RST = cu_CU_2_DP_RST;

assign dp_SHFTENABLE_1 = cu_SHFTENABLE_1;
assign dp_SHFTENABLE_2 = cu_SHFTENABLE_2;
assign dp_MUX_SELECT = cu_MUX_SELECT;

assign cu_SAMPLE = dp_SAMPLE;

slave_DP dp
(
.clk(CLK),
.cu_2_dp_rst(dp_CU_2_DP_RST),
.chipSelect(CHIPSELECT),
.MOSI(MOSI),
.shftEnable_1(dp_SHFTENABLE_1),
.shftEnable_2(dp_SHFTENABLE_2),
.mux_select(dp_MUX_SELECT),
.red_led_enb(dp_RED_LED_ENB),
.blue_led_enb(dp_BLUE_LED_ENB),
.sample(dp_SAMPLE),
.RED_LED_REG(RED_LED),
.BLUE_LED_REG(BLUE_LED),
.MISO(MISO)
);

slave_CU cu
(
.clk(CLK),
.rst(RST),
.chipSelect(CHIPSELECT),
.sample(cu_SAMPLE),
.red_led_enb(cu_RED_LED_ENB),
.blue_led_enb(cu_BLUE_LED_ENB),
.cu_2_dp_rst(cu_CU_2_DP_RST),
.shftEnable_1(cu_SHFTENABLE_1),
.shftEnable_2(cu_SHFTENABLE_2),
.mux_select(cu_MUX_SELECT)
);


endmodule