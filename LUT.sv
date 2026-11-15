module LookupTable  (
	input [4:0] address, 
	output reg [18:0] data
);

always @(*) begin
	case(address)
		5'd0: data <= 19'd102944;
		5'd1: data <= 19'd60771;
		5'd2: data <= 19'd32110;
		5'd3: data <= 19'd16299;
	    5'd4: data <= 19'd8181;
		5'd5: data <= 19'd4095;
		5'd6: data <= 19'd2048;
		5'd7: data <= 19'd1024;
		5'd8: data <= 19'd512;
		5'd9: data <= 19'd256;
		5'd10: data <= 19'd128;
		5'd11: data <= 19'd64;
		5'd12: data <= 19'd32;
		5'd13: data <= 19'd16;
		5'd14: data <= 19'd8;
		5'd15: data <= 19'd4;
	endcase
end


endmodule



