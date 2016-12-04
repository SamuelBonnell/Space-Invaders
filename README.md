# Space-Invaders
Summary:
This game was created for ECE 287 with Peter Jamieson at Miami University. The game we created is a version of Space Invaders. You are a ship at the bottom of the screen who has to shoot a group of aliens that are systematically moving down the screen towards you. The ship is only able to move left or right and can fire only a single bullet at a time. If an Alien reaches the bottom, then you die and lose the game. We created 15 aliens that you will have to shoot before they reach the bottom.

Problems:
We struggled implementing both of the peripherals The PS/2 Keyboard and the VGA cable were new to us, and we had never worked with them before. Also creating interaction between two different objects was challenging.
-	The Keyboard was much easier because we simply had to figure out the variables for every key, which we found online. After that we simply implemented it using Verilog. Another challenge along with this is that once a key is pushed the input stays active. We were able to figure out how to have the ship only move whenever the button was being pushed, by simply changing the code slightly, but in a way we did not expect.
-	Using the VGA cord to connect the DE2 board to a monitor was much more difficult. First we had to understand how a VGA worked, then we had to understand how things are drawn on the monitor. Once we understood how the pixels on the monitor were counted and drawn we were better able to reverse-engineer the code we found online. This code gave a basis that we could change and grow in order to create what we wanted on the screen.
-	Another difficult task was creating the collision with the bullet and the aliens. Both the aliens and the bullet are moving at the same time, so we had to get very specific as to the dimensions and coordinates of when to detect a collision. The things we found from other teams was to general and did not properly work with our game, so we had to create new, more descriptive if statements.


Citations:
We used this website as a guide to creating the format of the game. We reverse-engineered the code for the VGA in order to understand it and implement it for our game.
http://www.instructables.com/id/Snake-on-an-FPGA-Verilog/ 
