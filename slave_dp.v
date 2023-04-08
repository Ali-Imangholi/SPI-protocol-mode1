`timescale 1ns / 1ps
module slave_DP
(
input clk,
input cu_2_dp_rst,
input chipSelect,
input MOSI,
input shftEnable_1,
input shftEnable_2,
input mux_select,
input red_led_enb,
input blue_led_enb,
output sample,
output [6:0]RED_LED_REG,
output [6:0]BLUE_LED_REG,
output MISO
);

wire [7:0]outShiftReg_1;
wire [7:0]outShiftReg_2;

assign RED_LED_REG = (cu_2_dp_rst)?7'b0000000:(red_led_enb & chipSelect)?outShiftReg_1[7:1]:RED_LED_REG;
assign BLUE_LED_REG = (cu_2_dp_rst)?7'b0000000:(blue_led_enb & chipSelect)?outShiftReg_2[7:1]:BLUE_LED_REG;

sampler sampler_1(.clk(clk), .rst(cu_2_dp_rst), .MOSI(MOSI), .chipSelect(chipSelect), .sample(sample));
shiftRegister reg_1(.clk(clk), .rst(cu_2_dp_rst), .in(sample), .shftEnable(shftEnable_1), .out(outShiftReg_1));
shiftRegister reg_2(.clk(clk), .rst(cu_2_dp_rst), .in(sample), .shftEnable(shftEnable_2), .out(outShiftReg_2));
mux mux_1(.a(outShiftReg_1[0]), .b(outShiftReg_2[0]), .select_0(mux_select), .select_1(chipSelect), .c(MISO));


endmodule

