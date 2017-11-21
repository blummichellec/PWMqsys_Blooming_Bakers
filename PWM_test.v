module PWM_test #(parameter n = 8, parameter m = 4)(
input CLOCK_50, 
input [1:0] KEY,
input [17:0] SW,
output [n:0] LEDG,
output [35:0] GPIO
);

wire s, t, h, mil;
wire [n:0] sw_period, sw_duty ;

//assign the first 8 switches as the brightness and the rest are the frequency
assign sw_duty[n-1:0] = SW[n-1:0];
assign sw_period[n:0] = SW[17:n];


//setting variables for the core. 
 PWM_core run0( 
 .reset(KEY[1]),
 .clk(mil),
 .switch_in(sw_duty),
 .pulse_period(sw_period),
 .byteenable(4'b1111),
 .out(LEDG[n]),
 .out_pin(GPIO[m])
);


//extracting data from the clock divider. 
 clock_divider clock0(
	CLOCK_50,
	s,		//Seconds
	t,		//Tenths of seconds
	h,		//Hundredths of seconds
	mil		//milliseconds
	);

endmodule