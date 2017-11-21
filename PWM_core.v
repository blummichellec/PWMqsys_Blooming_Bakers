module PWM_core #(parameter n = 8, parameter m = 4)( 
input reset, clk,
input [n-1:0] switch_in,
input [n:0] pulse_period,
input [m-1:0] byteenable,
 output reg out, out_pin
);


reg [n-1:0] duty_cycle, counter;

//It runs on the edge to increase accuracy.
always@(posedge clk or negedge reset)
begin
	
	//if reset button is pressed
   if(~reset) 
   begin
		counter <= 32'b1; 
		duty_cycle <= 32'b0;
	end
	
	//when LED should be high
	else if(counter == pulse_period)
	begin
		counter <= 32'b1;
	end
	
	//increment counter and set LED to level of dimness
	else 
	begin
		counter <= counter + 1'b1;
		if(byteenable[0]) duty_cycle[7:0] <= switch_in[7:0];
	end
	
end 

//It runs on the edge to increase accuracy.
always@(posedge clk)
begin
	//set LED to high and sent output to pin
	if(counter <= duty_cycle)
	begin
		out = 1'b1;
		out_pin = 1'b1;
	end
	//set LED to low and send output to pin
	else 
	begin
		out = 1'b0;
		out_pin = 1'b0;
	end
		
end
endmodule