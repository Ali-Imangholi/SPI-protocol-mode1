`timescale 1ns / 1ps
module MasterModeling
#(parameter HowManyDataYouWantTransfer = 16, clkDuration = 20)
(
input clk,
input rst,
input MISO,
output reg chipSelect,
output reg MOSI
);

// Master data
reg [7:0]Master[0:HowManyDataYouWantTransfer-1];
initial
begin
	Master[0] = 8'b00000010;
	Master[1] = 8'b00000100;
	Master[2] = 8'b00001000;
	Master[3] = 8'b00010000;
	Master[4] = 8'b00100000;
	Master[5] = 8'b01000000;
	Master[6] = 8'b10000000;
	Master[7] = 8'b00000000; // turn of red led
	
	Master[8] = 8'b00000011;
	Master[9] = 8'b00000101;
	Master[10] = 8'b00001001;
	Master[11] = 8'b00010001;
	Master[12] = 8'b00100001;
	Master[13] = 8'b01000001;
	Master[14] = 8'b10000001;
	Master[15] = 8'b00000001; // turn of blue led
end

reg shftEnable;
reg loadEnable;
reg [7:0]MasterShiftReg;
reg sample_frome_MISO;
reg rst_master_shift_register;
reg end_of_rest_state;
reg start_rest, end_rest;
integer i=0;

reg [3:0] nextState, presentState;
parameter [3:0] reset = 4'b0000,
				idel  = 4'b0001,
			    bit_0 = 4'b0010,
				bit_1 = 4'b0011,
				bit_2 = 4'b0100,
				bit_3 = 4'b0101,
				bit_4 = 4'b0110,
				bit_5 = 4'b0111,
				bit_6 = 4'b1000,
				bit_7 = 4'b1001,
			    rest  = 4'b1010;
				

always@(posedge clk, posedge rst)
begin
	if(rst == 1'b1)
		MasterShiftReg <=0;
	else if(loadEnable==1'b1)
		MasterShiftReg <= Master[i];
	else if(shftEnable==1'b1)
	begin
		MasterShiftReg <= {sample_frome_MISO, MasterShiftReg[7:1]};
	end
	else
		MasterShiftReg <= MasterShiftReg;
end

assign MOSI = MasterShiftReg[0];


always@(negedge clk)
begin
	sample_frome_MISO <= MISO;
end




always@(posedge clk, posedge rst)
begin: presentState_nextState
	if(rst == 1'b1)
		presentState <= reset;
	else
		presentState <= nextState;
end
	
always@(presentState, end_of_rest_state)
begin: choose_nextState
	case(presentState)
	reset: nextState = idel;  // reseting master shift register
	idel:  nextState = bit_0; //load data into Master
	bit_0: nextState = bit_1;
	bit_1: nextState = bit_2;
	bit_2: nextState = bit_3;
	bit_3: nextState = bit_4;
	bit_4: nextState = bit_5;
	bit_5: nextState = bit_6;
	bit_6: nextState = bit_7;
	bit_7: nextState = rest;
	rest:  if(end_of_rest_state == 1'b1) nextState = idel; else nextState = rest; 
	endcase
end

always@(presentState)
begin
	{loadEnable, chipSelect, shftEnable, start_rest, rst_master_shift_register} = 5'b01000;// we must initialize output in order to synthesize tool don't make a latch.
	case(presentState)
	reset: rst_master_shift_register = 1'b1;
	idel: loadEnable = 1'b1;
	bit_0: {chipSelect,shftEnable} = 2'b01;
	bit_1: {chipSelect,shftEnable} = 2'b01;
	bit_2: {chipSelect,shftEnable} = 2'b01;
	bit_3: {chipSelect,shftEnable} = 2'b01;
	bit_4: {chipSelect,shftEnable} = 2'b01;
	bit_5: {chipSelect,shftEnable} = 2'b01;
	bit_6: {chipSelect,shftEnable} = 2'b01;
	bit_7: {chipSelect,shftEnable} = 2'b01;
	rest:
		begin
			start_rest = 1'b1;
			i = i + 1;
			if(i == HowManyDataYouWantTransfer)
				i = 0;
		end
	endcase
end

initial begin end_rest = 1'b0; end
always #(clkDuration * (HowManyDataYouWantTransfer+2)) end_rest = ~end_rest; // clock duration is: 20 [ns] or 20000 [ps]
assign end_of_rest_state = start_rest & end_rest;

endmodule

