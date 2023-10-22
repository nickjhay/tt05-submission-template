module tt_um_nickjhay_processor (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
	);

	// Bunch o state here

	// Register file

	wire reset = ! rst_n;


	// defaults
	assign uio_oe = 8'b0;
	assign uio_out = 8'b0;

	wire [7:0] sys_out[0:7];

	//wire [7:0] sys_out;

	systolic_cell s00 (
		.in(ui_in[0]), .out(sys_out[0][0]), .clk(clk), .reset(reset)
	);
	systolic_cell s01 (
		.in(ui_in[1]), .out(sys_out[0][1]), .clk(clk), .reset(reset)
	);
	systolic_cell s02 (
		.in(ui_in[2]), .out(sys_out[0][2]), .clk(clk), .reset(reset)
	);
	systolic_cell s03 (
		.in(ui_in[3]), .out(sys_out[0][3]), .clk(clk), .reset(reset)
	);
	systolic_cell s04 (
		.in(ui_in[4]), .out(sys_out[0][4]), .clk(clk), .reset(reset)
	);
	systolic_cell s05 (
		.in(ui_in[5]), .out(sys_out[0][5]), .clk(clk), .reset(reset)
	);
	systolic_cell s06 (
		.in(ui_in[6]), .out(sys_out[0][6]), .clk(clk), .reset(reset)
	);
	systolic_cell s07 (
		.in(ui_in[7]), .out(sys_out[0][7]), .clk(clk), .reset(reset)
	);

	systolic_cell s10 (
		.in(sys_out[0][0]), .out(sys_out[1][0]), .clk(clk), .reset(reset)
	);
	systolic_cell s11 (
		.in(sys_out[0][1]), .out(sys_out[1][1]), .clk(clk), .reset(reset)
	);
	systolic_cell s12 (
		.in(sys_out[0][2]), .out(sys_out[1][2]), .clk(clk), .reset(reset)
	);
	systolic_cell s13 (
		.in(sys_out[0][3]), .out(sys_out[1][3]), .clk(clk), .reset(reset)
	);
	systolic_cell s14 (
		.in(sys_out[0][4]), .out(sys_out[1][4]), .clk(clk), .reset(reset)
	);
	systolic_cell s15 (
		.in(sys_out[0][5]), .out(sys_out[1][5]), .clk(clk), .reset(reset)
	);
	systolic_cell s16 (
		.in(sys_out[0][6]), .out(sys_out[1][6]), .clk(clk), .reset(reset)
	);
	systolic_cell s17 (
		.in(sys_out[0][7]), .out(sys_out[1][7]), .clk(clk), .reset(reset)
	);	

	systolic_cell s20 (
		.in(sys_out[1][0]), .out(sys_out[2][0]), .clk(clk), .reset(reset)
	);
	systolic_cell s21 (
		.in(sys_out[1][1]), .out(sys_out[2][1]), .clk(clk), .reset(reset)
	);
	systolic_cell s22 (
		.in(sys_out[1][2]), .out(sys_out[2][2]), .clk(clk), .reset(reset)
	);
	systolic_cell s23 (
		.in(sys_out[1][3]), .out(sys_out[2][3]), .clk(clk), .reset(reset)
	);
	systolic_cell s24 (
		.in(sys_out[1][4]), .out(sys_out[2][4]), .clk(clk), .reset(reset)
	);
	systolic_cell s25 (
		.in(sys_out[1][5]), .out(sys_out[2][5]), .clk(clk), .reset(reset)
	);
	systolic_cell s26 (
		.in(sys_out[1][6]), .out(sys_out[2][6]), .clk(clk), .reset(reset)
	);
	systolic_cell s27 (
		.in(sys_out[1][7]), .out(sys_out[2][7]), .clk(clk), .reset(reset)
	);		

	systolic_cell s30 (
		.in(sys_out[2][0]), .out(sys_out[3][0]), .clk(clk), .reset(reset)
	);
	systolic_cell s31 (
		.in(sys_out[2][1]), .out(sys_out[3][1]), .clk(clk), .reset(reset)
	);
	systolic_cell s32 (
		.in(sys_out[2][2]), .out(sys_out[3][2]), .clk(clk), .reset(reset)
	);
	systolic_cell s33 (
		.in(sys_out[2][3]), .out(sys_out[3][3]), .clk(clk), .reset(reset)
	);
	systolic_cell s34 (
		.in(sys_out[2][4]), .out(sys_out[3][4]), .clk(clk), .reset(reset)
	);
	systolic_cell s35 (
		.in(sys_out[2][5]), .out(sys_out[3][5]), .clk(clk), .reset(reset)
	);
	systolic_cell s36 (
		.in(sys_out[2][6]), .out(sys_out[3][6]), .clk(clk), .reset(reset)
	);
	systolic_cell s37 (
		.in(sys_out[2][7]), .out(sys_out[3][7]), .clk(clk), .reset(reset)
	);			

	systolic_cell s40 (
		.in(sys_out[3][0]), .out(sys_out[4][0]), .clk(clk), .reset(reset)
	);
	systolic_cell s41 (
		.in(sys_out[3][1]), .out(sys_out[4][1]), .clk(clk), .reset(reset)
	);
	systolic_cell s42 (
		.in(sys_out[3][2]), .out(sys_out[4][2]), .clk(clk), .reset(reset)
	);
	systolic_cell s43 (
		.in(sys_out[3][3]), .out(sys_out[4][3]), .clk(clk), .reset(reset)
	);
	systolic_cell s44 (
		.in(sys_out[3][4]), .out(sys_out[4][4]), .clk(clk), .reset(reset)
	);
	systolic_cell s45 (
		.in(sys_out[3][5]), .out(sys_out[4][5]), .clk(clk), .reset(reset)
	);
	systolic_cell s46 (
		.in(sys_out[3][6]), .out(sys_out[4][6]), .clk(clk), .reset(reset)
	);
	systolic_cell s47 (
		.in(sys_out[3][7]), .out(sys_out[4][7]), .clk(clk), .reset(reset)
	);			

	systolic_cell s50 (
		.in(sys_out[4][0]), .out(sys_out[5][0]), .clk(clk), .reset(reset)
	);
	systolic_cell s51 (
		.in(sys_out[4][1]), .out(sys_out[5][1]), .clk(clk), .reset(reset)
	);
	systolic_cell s52 (
		.in(sys_out[4][2]), .out(sys_out[5][2]), .clk(clk), .reset(reset)
	);
	systolic_cell s53 (
		.in(sys_out[4][3]), .out(sys_out[5][3]), .clk(clk), .reset(reset)
	);
	systolic_cell s54 (
		.in(sys_out[4][4]), .out(sys_out[5][4]), .clk(clk), .reset(reset)
	);
	systolic_cell s55 (
		.in(sys_out[4][5]), .out(sys_out[5][5]), .clk(clk), .reset(reset)
	);
	systolic_cell s56 (
		.in(sys_out[4][6]), .out(sys_out[5][6]), .clk(clk), .reset(reset)
	);
	systolic_cell s57 (
		.in(sys_out[4][7]), .out(sys_out[5][7]), .clk(clk), .reset(reset)
	);			

	systolic_cell s60 (
		.in(sys_out[5][0]), .out(sys_out[6][0]), .clk(clk), .reset(reset)
	);
	systolic_cell s61 (
		.in(sys_out[5][1]), .out(sys_out[6][1]), .clk(clk), .reset(reset)
	);
	systolic_cell s62 (
		.in(sys_out[5][2]), .out(sys_out[6][2]), .clk(clk), .reset(reset)
	);
	systolic_cell s63 (
		.in(sys_out[5][3]), .out(sys_out[6][3]), .clk(clk), .reset(reset)
	);
	systolic_cell s64 (
		.in(sys_out[5][4]), .out(sys_out[6][4]), .clk(clk), .reset(reset)
	);
	systolic_cell s65 (
		.in(sys_out[5][5]), .out(sys_out[6][5]), .clk(clk), .reset(reset)
	);
	systolic_cell s66 (
		.in(sys_out[5][6]), .out(sys_out[6][6]), .clk(clk), .reset(reset)
	);
	systolic_cell s67 (
		.in(sys_out[5][7]), .out(sys_out[6][7]), .clk(clk), .reset(reset)
	);		

	systolic_cell s70 (
		.in(sys_out[6][0]), .out(sys_out[7][0]), .clk(clk), .reset(reset)
	);
	systolic_cell s71 (
		.in(sys_out[6][1]), .out(sys_out[7][1]), .clk(clk), .reset(reset)
	);
	systolic_cell s72 (
		.in(sys_out[6][2]), .out(sys_out[7][2]), .clk(clk), .reset(reset)
	);
	systolic_cell s73 (
		.in(sys_out[6][3]), .out(sys_out[7][3]), .clk(clk), .reset(reset)
	);
	systolic_cell s74 (
		.in(sys_out[6][4]), .out(sys_out[7][4]), .clk(clk), .reset(reset)
	);
	systolic_cell s75 (
		.in(sys_out[6][5]), .out(sys_out[7][5]), .clk(clk), .reset(reset)
	);
	systolic_cell s76 (
		.in(sys_out[6][6]), .out(sys_out[7][6]), .clk(clk), .reset(reset)
	);
	systolic_cell s77 (
		.in(sys_out[6][7]), .out(sys_out[7][7]), .clk(clk), .reset(reset)
	);		


	//for (int j=0; j<8; j++) 
	//	systolic_cell(
	//		ui_in[j], sys_out[0][j], clk
	//	);

	//for (int i=1; i<8; i++) 
	//	for (int j=0; j<8; j++) 
	//		systolic_cell(
	//			sys_out[i-1][j], sys_out[i][j], clk
	//		);

	assign uo_out = sys_out[7];

	// assign uo_out = sys_out;

endmodule


module systolic_cell (
	input wire in,
	output wire out,
	input wire clk,
	input wire reset,
	);

	reg acc;

	assign out = acc;

	always @(posedge clk) begin
		if (reset)
            acc <= 0;
        else
			acc <= in;
	end


endmodule



// ALU logic: 1, 2, 4, 8 bits for N (no negativity) with +, x with modulo, saturating, tropical

// start w/ 8x8 1bit example
// in/out just TSU

// one unit, into 8x8, systolic

// start with just shift registers
