//keyboard code modified from Instructables Verilog Snake game
module kbInput (KB_clk, data, action, rst);
	input KB_clk, data;
	output reg [3:0] action;
	inout rst;
	reg rstTemp = 1;
	reg [7:0] code;
	reg [10:0] keyCode, previousCode;
	wire recordNext = 0;
	integer count = 0;
	
	always@(negedge KB_clk)
	begin
		keyCode[count] = data;
		count = count + 1;
		if(count == 11)
		begin
			if(previousCode != 8'hF0) 
			begin
				code <= keyCode[8:1];
			end
			previousCode = keyCode[8:1];
			count = 0;
		end
	end
	
	assign rst = rstTemp;
	
	always@(code)
	begin
		if(code == 8'h29) //Spacebar
		begin
			action = 4'b0010;
			rstTemp = 0;
		end
		else if(code == 8'h6B) //Left Arrow
		begin
			action = 4'b0100;
			rstTemp = 0;
		end
		else if(code == 8'h74) //Right Arrow
		begin
			action = 4'b1000;
			rstTemp = 0;
		end
		else if(code == 8'h5A) //enter
		begin
			rstTemp = 1;
		end
		else action <= 4'b0000; //do nothing
	end
endmodule
