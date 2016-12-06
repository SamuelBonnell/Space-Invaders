module space_invaders (start, master_clk, KB_clk, data, DAC_clk, VGA_R, VGA_G, VGA_B, VGA_hSync, VGA_vSync, blank_n);
	input master_clk, KB_clk, data; //50MHz
	input start; //acts as a reset
	output reg [7:0]VGA_R, VGA_G, VGA_B;  //Red, Green, Blue VGA signals
	output VGA_hSync, VGA_vSync, DAC_clk, blank_n; //Horizontal and Vertical sync signals
	wire [9:0] xCount; //x pixel
	wire [9:0] yCount; //y pixel
	
	wire VGA_clk; //25 MHz
	wire R;
	wire G;
	wire B;
	
	wire [4:0] direction; //keyboard inputs
	
	//ship
	reg [9:0] shipX[0:127]; //ship x pos
	reg [8:0] shipY[0:127]; //ship y pos
	reg ship;
	
	//bullet
	reg [9:0] bulletX[0:127]; //bullet x pos
	reg [8:0] bulletY[0:127]; //bullet y pos
	reg bulletLocate; //indicates whether bullet has been fired or not
	reg bullet;
	reg [14:0] dead; //indicates which aliens are destroyed
	
	integer aliensKilled; //counts number of aliens killed
	
	reg winaliens;
	reg [1:0] winloss;
	reg L1, L2, W1, W2, W3, W4, W5; //used to draw an L or W
	
	//each aliens x and y pos
	reg [9:0] A1alienX[0:127];
	reg [8:0] A1alienY[0:127];
	reg [9:0] A2alienX[0:127];
	reg [8:0] A2alienY[0:127];
	reg [9:0] A3alienX[0:127];
	reg [8:0] A3alienY[0:127];
	reg [9:0] A4alienX[0:127];
	reg [8:0] A4alienY[0:127];
	reg [9:0] A5alienX[0:127];
	reg [8:0] A5alienY[0:127];
	
	reg [9:0] B1alienX[0:127];
	reg [8:0] B1alienY[0:127];
	reg [9:0] B2alienX[0:127];
	reg [8:0] B2alienY[0:127];
	reg [9:0] B3alienX[0:127];
	reg [8:0] B3alienY[0:127];
	reg [9:0] B4alienX[0:127];
	reg [8:0] B4alienY[0:127];
	reg [9:0] B5alienX[0:127];
	reg [8:0] B5alienY[0:127];
	
	reg [9:0] C1alienX[0:127];
	reg [8:0] C1alienY[0:127];
	reg [9:0] C2alienX[0:127];
	reg [8:0] C2alienY[0:127];
	reg [9:0] C3alienX[0:127];
	reg [8:0] C3alienY[0:127];
	reg [9:0] C4alienX[0:127];
	reg [8:0] C4alienY[0:127];
	reg [9:0] C5alienX[0:127];
	reg [8:0] C5alienY[0:127];
	
	reg A1alien;
	reg A2alien;
	reg A3alien;
	reg A4alien;
	reg A5alien;
	
	reg B1alien;
	reg B2alien;
	reg B3alien;
	reg B4alien;
	reg B5alien;
	
	reg C1alien;
	reg C2alien;
	reg C3alien;
	reg C4alien;
	reg C5alien;
	
	//end alien
	
	reg right; //which direction aliens are currently moving
	
	integer count1, speed; //used to control speed of alien movement
	
	wire update, reset;
	
	
	clk_reduce reduce1(master_clk, VGA_clk); //Reduces 50MHz clock to 25MHz
	VGA_gen gen1(VGA_clk, xCount, yCount, displayArea, VGA_hSync, VGA_vSync, blank_n);//Generates xCount, yCount and horizontal/vertical sync signals
	kbInput kbIn(KB_clk, data, direction, reset); //gets keyboard input
	updateClk UPDATE(master_clk, update);
	
	assign DAC_clk = VGA_clk;
	
	/////////////////////////////////////////////////////winloss
	
	always@(posedge update)
	begin
		if (start)
			begin
			if (winaliens == 1'b1)
				begin
				winloss = 2'b01; //loss
				end
			else if (aliensKilled >= 15)
				begin
				winloss = 2'b10; //win
				end
			end
		else if (~start)
			winloss = 2'b00; //playing
			
	end
			
	
	/////////////////////////////////////////////////////ship movement, based from keyboard input
	
	always@(posedge update)
	begin
		if (start)
		begin
			case(direction)
				4'b0100: shipX[0] <= (shipX[0] - 10);
				4'b1000: shipX[0] <= (shipX[0] + 10);
			endcase	
		end
		else if(~start) //initial ship xy pos
		begin
			shipX[0] = 200;
			shipY[0] = 450;
		end
	
	end
	
	////////////////////////////////////////////////////bullet
	always@(posedge update)
	begin
		if (start)
		begin
			if (bulletLocate == 1'b0)
			begin
				case (direction)			//when spacebar pressed moves bullet to ships location, only happens if bullet not moving
					4'b0010: begin
								bulletLocate = 1'b1;
								bulletX[0] <= (shipX[0] + 15);
								bulletY[0] <= (shipY[0]);
								end
				endcase
			end
			else if (bulletLocate == 1'b1)
			begin
			///////////////////////////////////////////////////////////////collisions - bullet & alien
			//////////////////if collision or edge of screen, resets bullet to be ready to fire again, marks alien dead and adds to count
				if (((bulletX[0] >= A1alienX[0]) && (bulletX[0] <= (A1alienX[0] + 35)) && (bulletY[0] >= A1alienY[0]) && (bulletY[0] <= (A1alienY[0] + 35))) && (dead[0] == 1'b1))
					begin
					bulletLocate = 1'b0; 
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[0] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
				else if (((bulletX[0] >= A2alienX[0]) && (bulletX[0] <= (A2alienX[0] + 35)) && (bulletY[0] >= A2alienY[0]) && (bulletY[0] <= (A2alienY[0] + 35))) && (dead[1] == 1'b1))
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[1] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
				else if (((bulletX[0] >= A3alienX[0]) && (bulletX[0] <= (A3alienX[0] + 35)) && (bulletY[0] >= A3alienY[0]) && (bulletY[0] <= (A3alienY[0] + 35))) && (dead[2] == 1'b1))
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[2] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
				else if (((bulletX[0] >= A4alienX[0]) && (bulletX[0] <= (A4alienX[0] + 35)) && (bulletY[0] >= A4alienY[0]) && (bulletY[0] <= (A4alienY[0] + 35))) && (dead[3] == 1'b1))
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[3] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
				else if (((bulletX[0] >= A5alienX[0]) && (bulletX[0] <= (A5alienX[0] + 35)) && (bulletY[0] >= A5alienY[0]) && (bulletY[0] <= (A5alienY[0] + 35))) && (dead[4] == 1'b1))
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[4] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
				else if (((bulletX[0] >= B1alienX[0]) && (bulletX[0] <= (B1alienX[0] + 25)) && (bulletY[0] >= B1alienY[0]) && (bulletY[0] <= (B1alienY[0] + 25))) && (dead[5] == 1'b1))
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[5] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
				else if (((bulletX[0] >= B2alienX[0]) && (bulletX[0] <= (B2alienX[0] + 25)) && (bulletY[0] >= B2alienY[0]) && (bulletY[0] <= (B2alienY[0] + 25))) && (dead[6] == 1'b1))
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[6] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
				else if (((bulletX[0] >= B3alienX[0]) && (bulletX[0] <= (B3alienX[0] + 25)) && (bulletY[0] >= B3alienY[0]) && (bulletY[0] <= (B3alienY[0] + 25))) && (dead[7] == 1'b1))
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[7] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
				else if (((bulletX[0] >= B4alienX[0]) && (bulletX[0] <= (B4alienX[0] + 25)) && (bulletY[0] >= B4alienY[0]) && (bulletY[0] <= (B4alienY[0] + 25))) && (dead[8] == 1'b1))
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[8] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
				else if (((bulletX[0] >= B5alienX[0]) && (bulletX[0] <= (B5alienX[0] + 25)) && (bulletY[0] >= B5alienY[0]) && (bulletY[0] <= (B5alienY[0] + 25))) && (dead[9] == 1'b1))
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[9] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
				else if (((bulletX[0] >= C1alienX[0]) && (bulletX[0] <= (C1alienX[0] + 15)) && (bulletY[0] >= C1alienY[0]) && (bulletY[0] <= (C1alienY[0] + 15))) && (dead[10] == 1'b1))
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[10] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
				else if (((bulletX[0] >= C2alienX[0]) && (bulletX[0] <= (C2alienX[0] + 15)) && (bulletY[0] >= C2alienY[0]) && (bulletY[0] <= (C2alienY[0] + 15))) && (dead[11] == 1'b1))
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[11] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
				else if (((bulletX[0] >= C3alienX[0]) && (bulletX[0] <= (C3alienX[0] + 15)) && (bulletY[0] >= C3alienY[0]) && (bulletY[0] <= (C3alienY[0] + 15))) && (dead[12] == 1'b1))
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[12] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
				else if (((bulletX[0] >= C4alienX[0]) && (bulletX[0] <= (C4alienX[0] + 15)) && (bulletY[0] >= C4alienY[0]) && (bulletY[0] <= (C4alienY[0] + 15))) && (dead[13] == 1'b1))
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[13] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
				else if (((bulletX[0] >= C5alienX[0]) && (bulletX[0] <= (C5alienX[0] + 15)) && (bulletY[0] >= C5alienY[0]) && (bulletY[0] <= (C5alienY[0] + 15))) && (dead[14] == 1'b1))
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					dead[14] = 1'b0;
					aliensKilled = aliensKilled + 1;
					end
			//////////////////////////////////////////////////////////////////end collsions
				else if (bulletY[0] <= 20)
					begin
					bulletLocate = 1'b0;
					bulletX[0] <= 650;
					bulletY[0] <= 50;
					end
				else
					bulletY[0] <= (bulletY[0] - 10); //bullet travels upward if no collision detected
			end
		end
		else if(~start)
		begin
			bulletLocate = 1'b0;
			bulletX[0] <= 650;
			bulletY[0] <= 50;
			dead = 15'b111111111111111; //each alien is alive
			aliensKilled = 0;
		end		
	end
		
	
	////////////////////////////////////////////////////aliens move
	
	always@(posedge update)
	begin
		if (start)
		begin
			if (count1 != speed) //determines alien movement speed
				count1 = count1 + 1;
			else
			begin
				count1 = 0;
				if (((A1alienY[0] >= 400) && dead[0]) | ((A2alienY[0] >= 400) && dead[1]) | ((A3alienY[0] >= 400) && dead[2]) | ((A4alienY[0] >= 400) && dead[3]) | ((A5alienY[0] >= 400) && dead[4]) |
					 ((B1alienY[0] >= 400) && dead[5]) | ((B2alienY[0] >= 400) && dead[6]) | ((B3alienY[0] >= 400) && dead[7]) | ((B4alienY[0] >= 400) && dead[8]) | ((B5alienY[0] >= 400) && dead[9]) |
					 ((C1alienY[0] >= 430) && dead[10]) | ((C2alienY[0] >= 430) && dead[11]) | ((C3alienY[0] >= 430) && dead[12]) | ((C4alienY[0] >= 430) && dead[13]) | ((C5alienY[0] >= 430) && dead[14]))
					begin
						winaliens = 1'b1; //aliens win when reach bottom of screen, stops movement after they win
					end
				else if (((A1alienX[0] <= 20) && dead[0]) | ((A2alienX[0] <= 20) && dead[1]) | ((A3alienX[0] <= 20) && dead[2]) | ((A4alienX[0] <= 20) && dead[3]) | ((A5alienX[0] <= 20) && dead[4]) |
					 ((B1alienX[0] <= 20) && dead[5]) | ((B2alienX[0] <= 20) && dead[6]) | ((B3alienX[0] <= 20) && dead[7]) | ((B4alienX[0] <= 20) && dead[8]) | ((B5alienX[0] <= 20) && dead[9]) |
					 ((C1alienX[0] <= 20) && dead[10]) | ((C2alienX[0] <= 20) && dead[11]) | ((C3alienX[0] <= 20) && dead[12]) | ((C4alienX[0] <= 20) && dead[13]) | ((C5alienX[0] <= 20) && dead[14]))
					begin //checks if any alive alien reaches screen left edge then moves them down and right
					A1alienY[0] <= (A1alienY[0] + 35);
					A1alienX[0] <= (A1alienX[0] + 20);
					A2alienY[0] <= (A2alienY[0] + 35);
					A2alienX[0] <= (A2alienX[0] + 20);
					A3alienY[0] <= (A3alienY[0] + 35);
					A3alienX[0] <= (A3alienX[0] + 20);
					A4alienY[0] <= (A4alienY[0] + 35);
					A4alienX[0] <= (A4alienX[0] + 20);
					A5alienY[0] <= (A5alienY[0] + 35);
					A5alienX[0] <= (A5alienX[0] + 20);
					
					B1alienY[0] <= (B1alienY[0] + 35);
					B1alienX[0] <= (B1alienX[0] + 20);
					B2alienY[0] <= (B2alienY[0] + 35);
					B2alienX[0] <= (B2alienX[0] + 20);
					B3alienY[0] <= (B3alienY[0] + 35);
					B3alienX[0] <= (B3alienX[0] + 20);
					B4alienY[0] <= (B4alienY[0] + 35);
					B4alienX[0] <= (B4alienX[0] + 20);
					B5alienY[0] <= (B5alienY[0] + 35);
					B5alienX[0] <= (B5alienX[0] + 20);
					
					C1alienY[0] <= (C1alienY[0] + 35);
					C1alienX[0] <= (C1alienX[0] + 20);
					C2alienY[0] <= (C2alienY[0] + 35);
					C2alienX[0] <= (C2alienX[0] + 20);
					C3alienY[0] <= (C3alienY[0] + 35);
					C3alienX[0] <= (C3alienX[0] + 20);
					C4alienY[0] <= (C4alienY[0] + 35);
					C4alienX[0] <= (C4alienX[0] + 20);
					C5alienY[0] <= (C5alienY[0] + 35);
					C5alienX[0] <= (C5alienX[0] + 20);
					
					right = ~right; //sets movement direction to the right
					speed = speed - 1; //increases movement speed
					end
				else if (((A1alienX[0] >= 550) && dead[0]) | ((A2alienX[0] >= 550) && dead[1]) | ((A3alienX[0] >= 550) && dead[2]) | ((A4alienX[0] >= 550) && dead[3]) | ((A5alienX[0] >= 550) && dead[4]) |
					 ((B1alienX[0] >= 550) && dead[5]) | ((B2alienX[0] >= 550) && dead[6]) | ((B3alienX[0] >= 550) && dead[7]) | ((B4alienX[0] >= 550) && dead[8]) | ((B5alienX[0] >= 550) && dead[9]) |
					 ((C1alienX[0] >= 550) && dead[10]) | ((C2alienX[0] >= 550) && dead[11]) | ((C3alienX[0] >= 550) && dead[12]) | ((C4alienX[0] >= 550) && dead[13]) | ((C5alienX[0] >= 550) && dead[14]))
					begin //checks if any alive alien reaches screen right edge then moves them down and left
					A1alienY[0] <= (A1alienY[0] + 35);
					A1alienX[0] <= (A1alienX[0] - 20);
					A2alienY[0] <= (A2alienY[0] + 35);
					A2alienX[0] <= (A2alienX[0] - 20);
					A3alienY[0] <= (A3alienY[0] + 35);
					A3alienX[0] <= (A3alienX[0] - 20);
					A4alienY[0] <= (A4alienY[0] + 35);
					A4alienX[0] <= (A4alienX[0] - 20);
					A5alienY[0] <= (A5alienY[0] + 35);
					A5alienX[0] <= (A5alienX[0] - 20);
					
					B1alienY[0] <= (B1alienY[0] + 35);
					B1alienX[0] <= (B1alienX[0] - 20);
					B2alienY[0] <= (B2alienY[0] + 35);
					B2alienX[0] <= (B2alienX[0] - 20);
					B3alienY[0] <= (B3alienY[0] + 35);
					B3alienX[0] <= (B3alienX[0] - 20);
					B4alienY[0] <= (B4alienY[0] + 35);
					B4alienX[0] <= (B4alienX[0] - 20);
					B5alienY[0] <= (B5alienY[0] + 35);
					B5alienX[0] <= (B5alienX[0] - 20);
					
					C1alienY[0] <= (C1alienY[0] + 35);
					C1alienX[0] <= (C1alienX[0] - 20);
					C2alienY[0] <= (C2alienY[0] + 35);
					C2alienX[0] <= (C2alienX[0] - 20);
					C3alienY[0] <= (C3alienY[0] + 35);
					C3alienX[0] <= (C3alienX[0] - 20);
					C4alienY[0] <= (C4alienY[0] + 35);
					C4alienX[0] <= (C4alienX[0] - 20);
					C5alienY[0] <= (C5alienY[0] + 35);
					C5alienX[0] <= (C5alienX[0] - 20);
					
					right = ~right; //sets movement direction to the left
					speed = speed - 1; //increases movement speed
					end
				else if (right) //moves aliens to the right
					begin
					A1alienX[0] <= (A1alienX[0] + 20);
					A2alienX[0] <= (A2alienX[0] + 20);
					A3alienX[0] <= (A3alienX[0] + 20);
					A4alienX[0] <= (A4alienX[0] + 20);
					A5alienX[0] <= (A5alienX[0] + 20);
					
					B1alienX[0] <= (B1alienX[0] + 20);
					B2alienX[0] <= (B2alienX[0] + 20);
					B3alienX[0] <= (B3alienX[0] + 20);
					B4alienX[0] <= (B4alienX[0] + 20);
					B5alienX[0] <= (B5alienX[0] + 20);
					
					C1alienX[0] <= (C1alienX[0] + 20);
					C2alienX[0] <= (C2alienX[0] + 20);
					C3alienX[0] <= (C3alienX[0] + 20);
					C4alienX[0] <= (C4alienX[0] + 20);
					C5alienX[0] <= (C5alienX[0] + 20);
					end
				else if (~right) //moves aliens to the left
					begin
					A1alienX[0] <= (A1alienX[0] - 20);
					A2alienX[0] <= (A2alienX[0] - 20);
					A3alienX[0] <= (A3alienX[0] - 20);
					A4alienX[0] <= (A4alienX[0] - 20);
					A5alienX[0] <= (A5alienX[0] - 20);
					
					B1alienX[0] <= (B1alienX[0] - 20);
					B2alienX[0] <= (B2alienX[0] - 20);
					B3alienX[0] <= (B3alienX[0] - 20);
					B4alienX[0] <= (B4alienX[0] - 20);
					B5alienX[0] <= (B5alienX[0] - 20);
					
					C1alienX[0] <= (C1alienX[0] - 20);
					C2alienX[0] <= (C2alienX[0] - 20);
					C3alienX[0] <= (C3alienX[0] - 20);
					C4alienX[0] <= (C4alienX[0] - 20);
					C5alienX[0] <= (C5alienX[0] - 20);
					end
			end
			
		end
		else if (~start) //original alien positions and speed
		begin
			right = 1'b1;
			count1 = 0;
			speed = 11;
			winaliens = 1'b0;
			
			A1alienX[0] = 100;
			A1alienY[0] = 120;
			A2alienX[0] = 155;
			A2alienY[0] = 120;
			A3alienX[0] = 210;
			A3alienY[0] = 120;
			A4alienX[0] = 265;
			A4alienY[0] = 120;
			A5alienX[0] = 320;
			A5alienY[0] = 120;
			
			B1alienX[0] = 105;
			B1alienY[0] = 80;
			B2alienX[0] = 160;
			B2alienY[0] = 80;
			B3alienX[0] = 215;
			B3alienY[0] = 80;
			B4alienX[0] = 270;
			B4alienY[0] = 80;
			B5alienX[0] = 325;
			B5alienY[0] = 80;
			
			C1alienX[0] = 110;
			C1alienY[0] = 50;
			C2alienX[0] = 165;
			C2alienY[0] = 50;
			C3alienX[0] = 220;
			C3alienY[0] = 50;
			C4alienX[0] = 275;
			C4alienY[0] = 50;
			C5alienX[0] = 330;
			C5alienY[0] = 50;
		end
		
	end
	
	///////////////////////////////////////////////////////////ship/alien size
	
	always@(posedge VGA_clk)
	begin
		if (winloss == 2'b10) //if win, draw W and don't display L
		begin
			W1 = (xCount > 120 && xCount < (170)) && (yCount > 20 && yCount < (300));
			W2 = (xCount > 169 && xCount < (220)) && (yCount > 200 && yCount < (250));
			W3 = (xCount > 220 && xCount < (270)) && (yCount > 150 && yCount < (200));
			W4 = (xCount > 270 && xCount < (321)) && (yCount > 200 && yCount < (250));
			W5 = (xCount > 320 && xCount < (370)) && (yCount > 20 && yCount < (300));
			ship = (xCount > shipX[0] && xCount < (shipX[0]+35)) && (yCount > shipY[0] && yCount < (shipY[0]+20)); //ship's size
			bullet = (xCount > bulletX[0] && xCount < (bulletX[0]+5)) && (yCount > bulletY[0] && yCount < (bulletY[0]+10)); //bullet's size
			L1 = 0; 
			L2 = 0;
		end
		else if (winloss == 2'b01) //if loss, draw L and don't display ship, bullet, or W.
		begin 
			L1 = (xCount > 220 && xCount < (270)) && (yCount > 20 && yCount < (300));
			L2 = (xCount > 220 && xCount < (370)) && (yCount > 250 && yCount < (300));
			ship = 0;
			bullet = 0;
			W1 = 0;
			W2 = 0;
			W3 = 0;
			W4 = 0;
			W5 = 0;
		end
		else if (winloss == 2'b00) //if playing, don't display L or W.
		begin 
			L1 = 0; 
			L2 = 0;
			ship = (xCount > shipX[0] && xCount < (shipX[0]+35)) && (yCount > shipY[0] && yCount < (shipY[0]+20));
			bullet = (xCount > bulletX[0] && xCount < (bulletX[0]+5)) && (yCount > bulletY[0] && yCount < (bulletY[0]+10));
			W1 = 0;
			W2 = 0;
			W3 = 0;
			W4 = 0;
			W5 = 0;
		end
		
		/////////////////////////////////sets each aliens size dependent on whether it has been killed or not
		if (dead[0] == 1'b1)
		A1alien = (xCount > A1alienX[0] && xCount < (A1alienX[0]+35)) && (yCount > A1alienY[0] && yCount < (A1alienY[0]+35));
		else A1alien = 0;
		if (dead[1] == 1'b1)
		A2alien = (xCount > A2alienX[0] && xCount < (A2alienX[0]+35)) && (yCount > A2alienY[0] && yCount < (A2alienY[0]+35));
		else A3alien = 0;
		if (dead[2] == 1'b1)
		A3alien = (xCount > A3alienX[0] && xCount < (A3alienX[0]+35)) && (yCount > A3alienY[0] && yCount < (A3alienY[0]+35));
		else A3alien = 0;
		if (dead[3] == 1'b1)
		A4alien = (xCount > A4alienX[0] && xCount < (A4alienX[0]+35)) && (yCount > A4alienY[0] && yCount < (A4alienY[0]+35));
		else A4alien = 0;
		if (dead[4] == 1'b1)
		A5alien = (xCount > A5alienX[0] && xCount < (A5alienX[0]+35)) && (yCount > A5alienY[0] && yCount < (A5alienY[0]+35));
		else A5alien = 0;
		
		if (dead[5] == 1'b1)
		B1alien = (xCount > B1alienX[0] && xCount < (B1alienX[0]+25)) && (yCount > B1alienY[0] && yCount < (B1alienY[0]+25));
		else B1alien = 0;
		if (dead[6] == 1'b1)
		B2alien = (xCount > B2alienX[0] && xCount < (B2alienX[0]+25)) && (yCount > B2alienY[0] && yCount < (B2alienY[0]+25));
		else B2alien = 0;
		if (dead[7] == 1'b1)
		B3alien = (xCount > B3alienX[0] && xCount < (B3alienX[0]+25)) && (yCount > B3alienY[0] && yCount < (B3alienY[0]+25));
		else B3alien = 0;
		if (dead[8] == 1'b1)
		B4alien = (xCount > B4alienX[0] && xCount < (B4alienX[0]+25)) && (yCount > B4alienY[0] && yCount < (B4alienY[0]+25));
		else B4alien = 0;
		if (dead[9] == 1'b1)
		B5alien = (xCount > B5alienX[0] && xCount < (B5alienX[0]+25)) && (yCount > B5alienY[0] && yCount < (B5alienY[0]+25));
		else B5alien = 0;
		
		if (dead[10] == 1'b1)
		C1alien = (xCount > C1alienX[0] && xCount < (C1alienX[0]+15)) && (yCount > C1alienY[0] && yCount < (C1alienY[0]+15));
		else C1alien = 0;
		if (dead[11] == 1'b1)
		C2alien = (xCount > C2alienX[0] && xCount < (C2alienX[0]+15)) && (yCount > C2alienY[0] && yCount < (C2alienY[0]+15));
		else C2alien = 0;
		if (dead[12] == 1'b1)
		C3alien = (xCount > C3alienX[0] && xCount < (C3alienX[0]+15)) && (yCount > C3alienY[0] && yCount < (C3alienY[0]+15));
		else C3alien = 0;
		if (dead[13] == 1'b1)
		C4alien = (xCount > C4alienX[0] && xCount < (C4alienX[0]+15)) && (yCount > C4alienY[0] && yCount < (C4alienY[0]+15));
		else C4alien = 0;
		if (dead[14] == 1'b1)
		C5alien = (xCount > C5alienX[0] && xCount < (C5alienX[0]+15)) && (yCount > C5alienY[0] && yCount < (C5alienY[0]+15));
		else C5alien = 0;
	end
	
	///////////////////////////////////////////////////////////VGA

										
	assign B = (bullet | W1 | W2 | W3 | W4 | W5); //makes bullet and W blue
	assign G = (A1alien | A2alien | A3alien | A4alien | A5alien | B1alien | B2alien | B3alien | B4alien | B5alien | C1alien | C2alien | C3alien | C4alien | C5alien);	 //makes aliens green			
	assign R = (ship | L1 | L2); //makes ship and L red

	always@(posedge VGA_clk) //outputs to VGA module and screen
	begin
		VGA_R = {8{R}};
		VGA_G = {8{G}};
		VGA_B = {8{B}};
	end 
	
endmodule
