//keyboard code from Isaac Steiger with some modifications
module kbInput (
  input clk,
  input PS2_DATA,
  input PS2_CLOCK,
  output reg [3:0] action
);


parameter idle    = 2'b01;
parameter receive = 2'b10;
parameter ready   = 2'b11;

reg [7:0] keycode;
reg [7:0] previousKey; 
reg [1:0]  state=idle;
reg [15:0] rxtimeout=16'b0000000000000000;
reg [10:0] rxregister=11'b11111111111;
reg [1:0]  datasr=2'b11;
reg [1:0]  clksr=2'b11;
reg [7:0]  rxdata;


reg datafetched;
reg rxactive;
reg dataready;

always @(posedge clk ) 
begin 
  if(datafetched==1)
  begin
  	if(previousKey != 8'hF0)
	begin 
		keycode<=rxdata;
    end
	previousKey <=rxdata;
  end
end  
  
always @(posedge clk ) 
begin 
  rxtimeout<=rxtimeout+1;
  datasr <= {datasr[0],PS2_DATA};
  clksr  <= {clksr[0],PS2_CLOCK};


  if(clksr==2'b10)
    rxregister<= {datasr[1],rxregister[10:1]};


  case (state) 
    idle: 
    begin
      rxregister <=11'b11111111111;
      rxactive   <=0;
      dataready  <=0;
		datafetched <=0;
      rxtimeout  <=16'b0000000000000000;
      if(datasr[1]==0 && clksr[1]==1)
      begin
        state<=receive;
        rxactive<=1;
      end   
    end
    
    receive:
    begin
      if(rxtimeout==50000)
        state<=idle;
      else if(rxregister[0]==0)
      begin
        dataready<=1;
        rxdata<=rxregister[8:1];
        state<=ready;
        datafetched<=1;
      end
    end
    
    ready: 
    begin
      if(datafetched==1)
      begin
        state     <=idle;
        dataready <=0;
        rxactive  <=0;
		 datafetched <=0;
      end  
    end  
  endcase
end 


	always@(keycode)
	begin
		if(keycode == 8'h29) //Spacebar
		begin
			action = 4'b0010;
		end
		else if(keycode == 8'hE06B) //Left Arrow
		begin
			action = 4'b0100;
		end
		else if(keycode == 8'hE074) //Right Arrow
		begin
			action = 4'b1000;
		end
		else action = 4'b0000;
	end
endmodule
