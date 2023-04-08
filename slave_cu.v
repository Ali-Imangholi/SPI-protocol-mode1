`timescale 1ns / 1ps
module slave_CU
(
input clk,
input rst,
input chipSelect,
input sample,
output reg red_led_enb,
output reg blue_led_enb,
output reg cu_2_dp_rst,
output reg shftEnable_1,
output reg shftEnable_2,
output reg mux_select
);

reg RegAddress;

// state machine
reg [3:0] nextState, presentState;
parameter [3:0] reset      = 4'b0000,    // reseting
				idel_bit_0 = 4'b0001,
				     bit_1 = 4'b0010,
				     bit_2 = 4'b0011,
				     bit_3 = 4'b0100,
				     bit_4 = 4'b0101,
				     bit_5 = 4'b0110,
				     bit_6 = 4'b0111,
				     bit_7 = 4'b1000;

always@(posedge clk, posedge rst)
begin: presentState_nextState
	if(rst == 1'b1)
		presentState <= reset;
	else
		presentState <= nextState;
end

always@(presentState, chipSelect)
begin: choose_nextState
	case(presentState)
	reset     :  nextState = idel_bit_0;
	idel_bit_0:  if(chipSelect == 1'b0) nextState = bit_1; else nextState = idel_bit_0;
	bit_1     :  nextState = bit_2;
	bit_2     :  nextState = bit_3;
	bit_3     :  nextState = bit_4;
	bit_4     :  nextState = bit_5;
	bit_5     :  nextState = bit_6;
	bit_6     :  nextState = bit_7;
	bit_7     :  nextState = idel_bit_0;
	endcase
end

always@(presentState, chipSelect, sample)
begin
	{cu_2_dp_rst, shftEnable_1, shftEnable_2, mux_select, red_led_enb, blue_led_enb} = 6'b000100;
	
	case(presentState)
	reset:
				begin
				if(chipSelect == 1'b1)
				    begin
						cu_2_dp_rst = 1'b1;
						RegAddress = 1'bz;
				    end
				end
				
	idel_bit_0:
				begin
				    
					if(RegAddress == 1'b0)
					begin	
						red_led_enb = 1'b1;
					end
					else if(RegAddress == 1'b1)
					begin
						blue_led_enb = 1'b1;
					end
					
					
					RegAddress = sample; // first bit which Master wants to transfer. this bit shows the address of slave Registers
					
					if(chipSelect == 1'b0)
						begin
							if(RegAddress == 1'b0)
								begin	
									shftEnable_1 = 1'b1;
									mux_select = 1'b0;
								end
							else if(RegAddress == 1'b1)
								begin
									shftEnable_2 = 1'b1;
									mux_select = 1'b1;
								end
						end
				end
				
	bit_1:
			begin
				if(RegAddress == 1'b0)
					begin	
						shftEnable_1 = 1'b1;
						mux_select = 1'b0;
					end
				else if(RegAddress == 1'b1)
					begin
						shftEnable_2 = 1'b1;
						mux_select = 1'b1;
					end			
			end
			
	bit_2:
			begin
				if(RegAddress == 1'b0)
					begin	
						shftEnable_1 = 1'b1;
						mux_select = 1'b0;
					end
				else if(RegAddress == 1'b1)
					begin
						shftEnable_2 = 1'b1;
						mux_select = 1'b1;
					end			
			end

	bit_3:
			begin
				if(RegAddress == 1'b0)
					begin	
						shftEnable_1 = 1'b1;
						mux_select = 1'b0;
					end
				else if(RegAddress == 1'b1)
					begin
						shftEnable_2 = 1'b1;
						mux_select = 1'b1;
					end			
			end

	bit_4:
			begin
				if(RegAddress == 1'b0)
					begin	
						shftEnable_1 = 1'b1;
						mux_select = 1'b0;
					end
				else if(RegAddress == 1'b1)
					begin
						shftEnable_2 = 1'b1;
						mux_select = 1'b1;
					end			
			end

	bit_5:
			begin
				if(RegAddress == 1'b0)
					begin	
						shftEnable_1 = 1'b1;
						mux_select = 1'b0;
					end
				else if(RegAddress == 1'b1)
					begin
						shftEnable_2 = 1'b1;
						mux_select = 1'b1;
					end			
			end

	bit_6:
			begin
				if(RegAddress == 1'b0)
					begin	
						shftEnable_1 = 1'b1;
						mux_select = 1'b0;
					end
				else if(RegAddress == 1'b1)
					begin
						shftEnable_2 = 1'b1;
						mux_select = 1'b1;
					end			
			end

	bit_7:
			begin
				if(RegAddress == 1'b0)
					begin	
						shftEnable_1 = 1'b1;
						mux_select = 1'b0;
					end
				else if(RegAddress == 1'b1)
					begin
						shftEnable_2 = 1'b1;
						mux_select = 1'b1;
					end			
			end
			
	endcase
end



endmodule

