module clock_divider #(parameter CLOCKFREQ = 50000000)(
	input clk,
	output reg s,		//Seconds
	output reg t,		//Tenths of seconds
	output reg h,		//Hundredths of seconds
	output reg m		//milliseconds
	);

	integer millicount = 0;
	integer hundredcount = 0;
	integer tencount = 0;
	integer secondcount = 0;
	
	//Divide the clock to get milliseconds:
	always @ (posedge clk)
	begin
		if (millicount == (CLOCKFREQ / 2000 - 1))
		begin
			millicount <= 0;
			m <= ~m;
		end
		else
			millicount <= millicount + 1;
	end

	//Divide the millisecond output to get hundredths:
	always @ (posedge clk)
	begin
		if (hundredcount == (CLOCKFREQ / 200 - 1))
		begin
			hundredcount <= 0;
			h <= ~h;
		end
		else
			hundredcount <= hundredcount + 1;
	end

	//Divide to get tenths:
	always @ (posedge clk)
	begin
		if (tencount == (CLOCKFREQ / 20 - 1))
		begin
			tencount <= 0;
			t <= ~t;
		end
		else
			tencount <= tencount + 1;
	end

	//Divide the tenths output to get seconds:
	always @ (posedge clk)
	begin
		if (secondcount == (CLOCKFREQ / 2 - 1))
		begin
			secondcount <= 0;
			s <= ~s;
		end
		else
			secondcount <= secondcount + 1;
	end
	
endmodule