`include "Cordic.sv"




module cordic_tb;

reg clock; reg reset; reg init_in; reg mode_init_in; reg [18:0]x_init_in; reg [18:0]y_init_in; reg [18:0]z_init_in; 
wire[18:0] x_out; wire[18:0] y_out; wire[18:0] z_out; wire done_out;
reg [18:0] cutoff_in;


reg[7:0] i = 8'd0;

CORDIC_CORE #(.PRECISION(19)) dut (//puts in 3 guard bits
	.clk(clock), .rst_async(reset), .init(init_in), .mode_init(mode_init_in), 
	.x_init(x_init_in), .y_init(y_init_in), .z_init(z_init_in),
	.x(x_out), .y(y_out), .z(z_out),
	.done(done_out), .cutoff_init(cutoff_in)
	);

initial begin
    clock = '0;
   #10;
    reset = '1;

   #10;
    reset = '0;
   #10;
    clock = '1;

   #10;
    clock = '0;

   #10;
    clock = '1;

   #10;
    clock = '0;
//after the clock goes low, we can set things up for the next:

    x_init_in = 19'd79594;
    y_init_in = 19'd0;
    z_init_in = 19'd0;
    mode_init_in = 1'b0;
    cutoff_in = 19'd113514;
    init_in = 1'b1;

   #10;
    clock = '1;

   #10;
    clock = '0;

    init_in = 1'b0;//set init low for once, so we can start it up again


    for(i = 8'd0; i < 8'd50; i = i + 1) begin

       #10;
        clock = 1'b1;
        $display("time: %t, x = %d, y = %d, z = %d, done = %d\n",$time, x_out, y_out, z_out, done_out);

       #10;
        clock = 1'b0;
    end

end

endmodule
