module cordic(
  output [31:0] sin,
  output [31:0] cos,
  input [31:0] theta,
	input clock
  );

	//parameter [31:0] mul = 32'h40000000,
	reg signed [31:0] k = 32'h26dd3b6a;
	parameter size = 32;
	integer j;


	reg signed [31:0] x [32:0];
	reg signed [31:0] y [32:0];
	reg signed [31:0] z [32:0];

	wire signed [31:0] atan_table [0:31];

	always @ (posedge clock)
	begin
		x[0] = k;
		y[0] = 32'h00000000;
	 	z[0] = theta;
	end

	genvar i;

	generate
		for (i=0; i<32; i=i+1)
		begin
			wire signed [31:0] x_s,y_s;
			wire signed z_s;
			
			assign x_s = x[i] >>> i;
			assign y_s = y[i] >>> i;
			assign z_s = z[i][31];

			
			always @ (posedge clock)
			begin
				x[i+1] <= z_s ? x[i] + y_s : x[i] - y_s;
				y[i+1] <= z_s ? y[i] - x_s : y[i] + x_s;
				z[i+1] <= z_s ? z[i] + atan_table[i] : z[i] - atan_table[i];
				//x[i+1] <= z[i][31] ? x[i] + y_s : x[i] - y_s;
				//y[i+1] <= z[i][31] ? y[i] - x_s : y[i] + x_s;
				//z[i+1] <= z[i][31] ? z[i] + atan_table[i] : z[i] - atan_table[i];
			end

		end
	endgenerate

	assign  cos = x[32];
	assign  sin = y[32];

	//arctan table

	assign atan_table[00] = 32'h3243f6a8;
	assign atan_table[01] = 32'h1dac6705;
	assign atan_table[02] = 32'h0fadbafc;
	assign atan_table[03] = 32'h07f56ea6;
	assign atan_table[04] = 32'h03feab76;
	assign atan_table[05] = 32'h01ffd55b;
	assign atan_table[06] = 32'h00fffaaa;
	assign atan_table[07] = 32'h007fff55;
	assign atan_table[08] = 32'h003fffea;
	assign atan_table[09] = 32'h001ffffd;
	assign atan_table[10] = 32'h000fffff;
	assign atan_table[11] = 32'h0007ffff;
	assign atan_table[12] = 32'h0003ffff;
	assign atan_table[13] = 32'h0001ffff;
	assign atan_table[14] = 32'h0000ffff;
	assign atan_table[15] = 32'h00007fff;
	assign atan_table[16] = 32'h00003fff;
	assign atan_table[17] = 32'h00001fff;
	assign atan_table[18] = 32'h00000fff;
	assign atan_table[19] = 32'h000007ff;
	assign atan_table[20] = 32'h000003ff;
	assign atan_table[21] = 32'h000001ff;
	assign atan_table[22] = 32'h000000ff;
	assign atan_table[23] = 32'h0000007f;
	assign atan_table[24] = 32'h0000003f;
	assign atan_table[25] = 32'h0000001f;
	assign atan_table[26] = 32'h0000000f;
	assign atan_table[27] = 32'h00000008;
	assign atan_table[28] = 32'h00000004;
	assign atan_table[29] = 32'h00000002;
	assign atan_table[30] = 32'h00000001;
	assign atan_table[31] = 32'h00000000;



endmodule

/*
primitive atan_table( atan, index);
	output atan;
	input index;
	table
		0 : 32'h3243f6a8;
		1 : 32'h1dac6705;
		2 : 32'h0fadbafc;
		3 : 32'h07f56ea6;
		4 : 32'h03feab76;
		5 : 32'h01ffd55b;
		6 : 32'h00fffaaa;
		7 : 32'h007fff55;
		8 : 32'h003fffea;
		9 : 32'h001ffffd;
		10: 32'h000fffff;
		11: 32'h0007ffff;
		12: 32'h0003ffff;
		13: 32'h0001ffff;
		14: 32'h0000ffff;
		15: 32'h00007fff;
		16: 32'h00003fff;
		17: 32'h00001fff;
		18: 32'h00000fff;
		19: 32'h000007ff;
		20: 32'h000003ff;
		21: 32'h000001ff;
		22: 32'h000000ff;
		23: 32'h0000007f;
		24: 32'h0000003f;
		25: 32'h0000001f;
		26: 32'h0000000f;
		27: 32'h00000008;
		28: 32'h00000004;
		29: 32'h00000002;
		30: 32'h00000001;
		31: 32'h00000000;
	endtable
endprimitive
*/

