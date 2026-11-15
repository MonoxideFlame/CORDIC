`include "LUT.sv"

//x y and z range from [-2, +2). X and Y need it because 1/K is ~1.6, and
//Z needs it because pi/2 is ~1.59. This means this range encompasses all
//possible ways for X and Y to stray
module CORDIC_CORE #(parameter PRECISION = 19)(//puts in 3 guard bits
	input clk, input rst_async, input init, input mode_init, 
	input[PRECISION-1:0] x_init, input[PRECISION-1:0]y_init, input[PRECISION-1:0]z_init,input[PRECISION-1:0] cutoff_init,
	output reg[PRECISION-1:0]  x, output reg[PRECISION-1:0] y, output reg[PRECISION-1:0]z,
	output reg done 
	);

	reg[4:0] i; //counter
    reg mode; //rotation or vectoring mode
    reg[PRECISION-1:0] cutoff;
    wire[PRECISION-1:0] LUT_in;
    
    LookupTable arctanTable(.address(i), .data(LUT_in));
    

	always @ (posedge rst_async or posedge clk) begin

		if(rst_async) begin
			x <= 'h0;
			y <= 'h0;
			z <= 'h0;
			i <= 'hffffffff;
            cutoff <= 'h0;
            mode <= '0;
			done <= '0;
		end else begin
			if(init) begin
				i <= 5'b0; 
				x <= x_init;
				y <= y_init;
				z <= z_init;
                mode <= mode_init;
				done <= 1'b0;
                cutoff <= cutoff_init;
			end else begin
				if(i != 16) begin
					done <= 1'b0;
					if(mode) begin //rotation mode
						if(z[PRECISION-1]) begin//z is less than zero, so rotate clockwise
							x <= x + (y >> i);
							y <= y - (x >> i);
							z <= z + LUT_in;
						end else begin//z is 0 or more, so rotate counter clockwise
							x <= x - (y >> i);
							y <= y + (x >> i);
						    z <= z - LUT_in;	
						end		
					end else begin
						if((y - cutoff) > 19'd262143) begin//y is less than cutoff, so rotate counter clockwise
							x <= x - (y >> i);
							y <= y + (x >> i);
						    z <= z + LUT_in;	
						end else begin//y is 0 or more, so rotate clockwise
							x <= x + (y >> i);
							y <= y - (x >> i); 
							z <= z - LUT_in;
						end		
					end
					i <= i + 1;
				end else begin
					done <= 1'b1;
				end
			end
		end
	end
endmodule
