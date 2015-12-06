module cordic_testbench;

	reg signed [31:0] test_a;
	reg clk;
	wire [31:0] sin,cos;

	integer i;

	cordic t(sin,cos,test_a,clk);

	initial #10000 $stop;

	initial
	begin

		clk = 'b0;
		forever
			#2	clk = !clk;

	end

	initial
	begin

		for(i=0; i<50; i=i+1)
		begin
			#160
			i= i;
		end

	end
	
	always @ (i)
		case(i)
			00 : test_a = 32'h00000000;
			01 : test_a = 32'h0202b7f3;
			02 : test_a = 32'h04056fe6;
			03 : test_a = 32'h060827d9;
			04 : test_a = 32'h080adfcc;
			05 : test_a = 32'h0a0d97c0;
			06 : test_a = 32'h0c104fb3;
			07 : test_a = 32'h0e1307a6;
			08 : test_a = 32'h1015bf99;
			09 : test_a = 32'h1218778c;
			10 : test_a = 32'h141b2f80;
			11 : test_a = 32'h161de773;
			12 : test_a = 32'h18209f66;
			13 : test_a = 32'h1a235759;
			14 : test_a = 32'h1c260f4c;
			15 : test_a = 32'h1e28c740;
			16 : test_a = 32'h202b7f33;
			17 : test_a = 32'h222e3726;
			18 : test_a = 32'h2430ef19;
			19 : test_a = 32'h2633a70c;
			20 : test_a = 32'h28365f00;
			21 : test_a = 32'h2a3916f3;
			22 : test_a = 32'h2c3bcee6;
			23 : test_a = 32'h2e3e86d9;
			24 : test_a = 32'h30413ecc;
			25 : test_a = 32'h3243f6c0;
			26 : test_a = 32'h3446aeb3;
			27 : test_a = 32'h364966a6;
			28 : test_a = 32'h384c1e99;
			29 : test_a = 32'h3a4ed68c;
			30 : test_a = 32'h3c518e80;
			31 : test_a = 32'h3e544673;
			32 : test_a = 32'h4056fe66;
			33 : test_a = 32'h4259b659;
			34 : test_a = 32'h445c6e4c;
			35 : test_a = 32'h465f2640;
			36 : test_a = 32'h4861de33;
			37 : test_a = 32'h4a649626;
			38 : test_a = 32'h4c674e19;
			39 : test_a = 32'h4e6a060c;
			40 : test_a = 32'h506cbe00;
			41 : test_a = 32'h526f75f3;
			42 : test_a = 32'h54722de6;
			43 : test_a = 32'h5674e5d9;
			44 : test_a = 32'h58779dcc;
			45 : test_a = 32'h5a7a55c0;
			46 : test_a = 32'h5c7d0db3;
			47 : test_a = 32'h5e7fc5a6;
			48 : test_a = 32'h60827d99;
			49 : test_a = 32'h6285358c;
		endcase

endmodule
