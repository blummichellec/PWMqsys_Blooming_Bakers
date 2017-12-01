module avalon_wrapper (
	input wire csi_clk,
	input wire rsi_rst_n, 
	input wire avs_s0_read, 
	input wire avs_s0_write, 
	input wire avs_s0_chip_select, 
	input wire [3:0] avs_s0_byteenable, 
	input wire[31:0] avs_s0_writedata, 
	input wire [1:0] avs_s0_address,
	output wire [31:0] avs_s0_readdata,
	output coe_pwm_out
	);
	
	reg [31:0] pulse_width, period;
	reg [31:0] read_data;
	reg enable;
	wire load_pulse_width, load_period, load_enable;
	wire read_pulse_width, read_period, read_enable;
	wire pwm_out;
	wire [3:0] load_pulse_width_lanes;
	wire [3:0] load_period_lanes;
	
	assign coe_pwm_out = pwm_out & enable;
	assign avs_s0_readdata = read_data;
	
	PWM_core PWM_core0(
		.clk(csi_clk), 
		.reset(rsi_rst_n),
		.pulse_period(period),
		.switch_in(pulse_width),
		.out(pwm_out)
	);
	
	/*
	Register Selection
	*/
	
	assign load_pulse_width = avs_s0_chip_select & avs_s0_write & (avs_s0_address == 0);
	assign load_period = avs_s0_chip_select & avs_S0_write & (avs_s0_address == 1);
	assign load_enable = avs_s0_chip_select & avs_S0_write & (avs_s0_address == 2);

	assign read_pulse_width = avs_s0_chip_select & avs_s0_read & (avs_s0_address == 0);
	assign read_period = avs_s0_chip_select & avs_s0_read & (avs_s0_address == 1);
	assign read_enable = avs_s0_chip_select & avs_s0_read & (avs_s0_address == 2);

	always @ (posedge clk or negedge rsi_rst_n) begin
		if (rsi_rst_n == 0) begin
			pulse_width <= 250000; 
			period <= 500000; 
			enable <= 1;
		end
		else
		if (load_pulse_width == 1) begin
			if  (avs_s0_byteenable[0] == 1) begin
				pulse_width[7:0] <=avs_s0_writedata[7:0];
			end 
			if  (avs_s0_byteenable[1] == 1) begin
				pulse_width[15:8] <=avs_s0_writedata[15:8];
			end 
			if  (avs_s0_byteenable[2] == 1) begin
				pulse_width[23:16] <=avs_s0_writedata[23:16];
			end 
			if  (avs_s0_byteenable[3] == 1) begin
				pulse_width[31:24] <=avs_s0_writedata[31:24];
			end 
		end
		if (read_pulse_width ==1) begin
			read_data <= pulse_width;
		end

		if (load_period == 1) begin
			if  (avs_s0_byteenable[0] == 1) begin
				period[7:0] <=avs_s0_writedata[7:0];
			end 
			if  (avs_s0_byteenable[1] == 1) begin
				period[15:8] <=avs_s0_writedata[15:8];
			end 
			if  (avs_s0_byteenable[2] == 1) begin
				period[23:16] <=avs_s0_writedata[23:16];
			end 
			if  (avs_s0_byteenable[3] == 1) begin
				period[31:24] <=avs_s0_writedata[31:24];
			end 
		end
		if (read_period ==1) begin
			read_data <= period;
		end
		if (load_enable== 1) begin
			if  (avs_s0_byteenable[0] == 1) begin
				enable[7:0] <=avs_s0_writedata[7:0];
			end 
		end
		if (enable ==1) begin
			read_data <= enable;
		end
	end

endmodule
