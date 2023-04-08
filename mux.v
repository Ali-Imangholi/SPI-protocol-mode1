`timescale 1ns / 1ps
module mux
(
input a, 
input b, 
input select_0,
input select_1, 
output c
);
// select_0 chose among a and b, but select_1 chose among result of previous mux and 1'bz according to chipselect signal
reg temp;
assign  temp = (~select_0)?a:b;
assign c = (~select_1)?temp:1'bz; //chip select is 0, so is active low

endmodule
