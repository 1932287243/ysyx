module onOffSwitch(
	input a,
	input b,
	output f
);
	assign f = a ^ b;
endmodule
