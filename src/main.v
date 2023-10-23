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

	// wire [7:0] sys_out[0:7];

	// whether to readout accumulated multiplcation data
	wire readout;
	assign readout = uio_in[0];

	wire [7:0] sys_out1[0:7];
	wire [7:0] sys_out2[0:7];

	// TODO: feed inputs alternately into cells, otherwise it collapses due to symmetry!
	reg [7:0] sys_in1;
	reg [7:0] sys_in1_buffer;
	reg [7:0] sys_in2;
	reg sys_in1_next;

	always @(posedge clk)
		if (reset) begin
			sys_in1 <= 8'b0;
			sys_in2 <= 8'b0;
			sys_in1_buffer <= 8'b0;
			sys_in1_next <= 1'b1;
		end else if (sys_in1_next) begin
			sys_in1 <= 8'b0;
			sys_in2 <= 8'b0;
			sys_in1_buffer <= ui_in;
			sys_in1_next <= 1'b0;
		end else begin
			sys_in1 <= sys_in1_buffer;
			sys_in2 <= ui_in;
			sys_in1_buffer <= 8'b0;
			sys_in1_next <= 1'b1;
		end

	// TODO: figure out how to compactly describe this
	//    using generate? how to name?
	// TODO: can we give placement hints to have this be grid-like??

	systolic_cell s00 (
		.in1(sys_in1[0]), .out1(sys_out1[0][0]), .in2(sys_in2[0]), .out2(sys_out2[0][0]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s01 (
		.in1(sys_in1[1]), .out1(sys_out1[0][1]), .in2(sys_out2[0][0]), .out2(sys_out2[0][1]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s02 (
		.in1(sys_in1[2]), .out1(sys_out1[0][2]), .in2(sys_out2[0][1]), .out2(sys_out2[0][2]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s03 (
		.in1(sys_in1[3]), .out1(sys_out1[0][3]), .in2(sys_out2[0][2]), .out2(sys_out2[0][3]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s04 (
		.in1(sys_in1[4]), .out1(sys_out1[0][4]), .in2(sys_out2[0][3]), .out2(sys_out2[0][4]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s05 (
		.in1(sys_in1[5]), .out1(sys_out1[0][5]), .in2(sys_out2[0][4]), .out2(sys_out2[0][5]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s06 (
		.in1(sys_in1[6]), .out1(sys_out1[0][6]), .in2(sys_out2[0][5]), .out2(sys_out2[0][6]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s07 (
		.in1(sys_in1[7]), .out1(sys_out1[0][7]), .in2(sys_out2[0][6]), .out2(sys_out2[0][7]), .readout(readout), .clk(clk), .reset(reset)
	);

	systolic_cell s10 (
		.in1(sys_out1[0][0]), .out1(sys_out1[1][0]), .in2(sys_in2[1]), .out2(sys_out2[1][0]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s11 (
		.in1(sys_out1[0][1]), .out1(sys_out1[1][1]), .in2(sys_out2[1][0]), .out2(sys_out2[1][1]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s12 (
		.in1(sys_out1[0][2]), .out1(sys_out1[1][2]), .in2(sys_out2[1][1]), .out2(sys_out2[1][2]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s13 (
		.in1(sys_out1[0][3]), .out1(sys_out1[1][3]), .in2(sys_out2[1][2]), .out2(sys_out2[1][3]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s14 (
		.in1(sys_out1[0][4]), .out1(sys_out1[1][4]), .in2(sys_out2[1][3]), .out2(sys_out2[1][4]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s15 (
		.in1(sys_out1[0][5]), .out1(sys_out1[1][5]), .in2(sys_out2[1][4]), .out2(sys_out2[1][5]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s16 (
		.in1(sys_out1[0][6]), .out1(sys_out1[1][6]), .in2(sys_out2[1][5]), .out2(sys_out2[1][6]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s17 (
		.in1(sys_out1[0][7]), .out1(sys_out1[1][7]), .in2(sys_out2[1][6]), .out2(sys_out2[1][7]), .readout(readout), .clk(clk), .reset(reset)
	);

	systolic_cell s20 (
		.in1(sys_out1[1][0]), .out1(sys_out1[2][0]), .in2(sys_in2[2]), .out2(sys_out2[2][0]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s21 (
		.in1(sys_out1[1][1]), .out1(sys_out1[2][1]), .in2(sys_out2[2][0]), .out2(sys_out2[2][1]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s22 (
		.in1(sys_out1[1][2]), .out1(sys_out1[2][2]), .in2(sys_out2[2][1]), .out2(sys_out2[2][2]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s23 (
		.in1(sys_out1[1][3]), .out1(sys_out1[2][3]), .in2(sys_out2[2][2]), .out2(sys_out2[2][3]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s24 (
		.in1(sys_out1[1][4]), .out1(sys_out1[2][4]), .in2(sys_out2[2][3]), .out2(sys_out2[2][4]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s25 (
		.in1(sys_out1[1][5]), .out1(sys_out1[2][5]), .in2(sys_out2[2][4]), .out2(sys_out2[2][5]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s26 (
		.in1(sys_out1[1][6]), .out1(sys_out1[2][6]), .in2(sys_out2[2][5]), .out2(sys_out2[2][6]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s27 (
		.in1(sys_out1[1][7]), .out1(sys_out1[2][7]), .in2(sys_out2[2][6]), .out2(sys_out2[2][7]), .readout(readout), .clk(clk), .reset(reset)
	);

	systolic_cell s30 (
		.in1(sys_out1[2][0]), .out1(sys_out1[3][0]), .in2(sys_in2[3]), .out2(sys_out2[3][0]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s31 (
		.in1(sys_out1[2][1]), .out1(sys_out1[3][1]), .in2(sys_out2[3][0]), .out2(sys_out2[3][1]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s32 (
		.in1(sys_out1[2][2]), .out1(sys_out1[3][2]), .in2(sys_out2[3][1]), .out2(sys_out2[3][2]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s33 (
		.in1(sys_out1[2][3]), .out1(sys_out1[3][3]), .in2(sys_out2[3][2]), .out2(sys_out2[3][3]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s34 (
		.in1(sys_out1[2][4]), .out1(sys_out1[3][4]), .in2(sys_out2[3][3]), .out2(sys_out2[3][4]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s35 (
		.in1(sys_out1[2][5]), .out1(sys_out1[3][5]), .in2(sys_out2[3][4]), .out2(sys_out2[3][5]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s36 (
		.in1(sys_out1[2][6]), .out1(sys_out1[3][6]), .in2(sys_out2[3][5]), .out2(sys_out2[3][6]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s37 (
		.in1(sys_out1[2][7]), .out1(sys_out1[3][7]), .in2(sys_out2[3][6]), .out2(sys_out2[3][7]), .readout(readout), .clk(clk), .reset(reset)
	);

	systolic_cell s40 (
		.in1(sys_out1[3][0]), .out1(sys_out1[4][0]), .in2(sys_in2[4]), .out2(sys_out2[4][0]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s41 (
		.in1(sys_out1[3][1]), .out1(sys_out1[4][1]), .in2(sys_out2[4][0]), .out2(sys_out2[4][1]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s42 (
		.in1(sys_out1[3][2]), .out1(sys_out1[4][2]), .in2(sys_out2[4][1]), .out2(sys_out2[4][2]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s43 (
		.in1(sys_out1[3][3]), .out1(sys_out1[4][3]), .in2(sys_out2[4][2]), .out2(sys_out2[4][3]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s44 (
		.in1(sys_out1[3][4]), .out1(sys_out1[4][4]), .in2(sys_out2[4][3]), .out2(sys_out2[4][4]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s45 (
		.in1(sys_out1[3][5]), .out1(sys_out1[4][5]), .in2(sys_out2[4][4]), .out2(sys_out2[4][5]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s46 (
		.in1(sys_out1[3][6]), .out1(sys_out1[4][6]), .in2(sys_out2[4][5]), .out2(sys_out2[4][6]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s47 (
		.in1(sys_out1[3][7]), .out1(sys_out1[4][7]), .in2(sys_out2[4][6]), .out2(sys_out2[4][7]), .readout(readout), .clk(clk), .reset(reset)
	);

	systolic_cell s50 (
		.in1(sys_out1[4][0]), .out1(sys_out1[5][0]), .in2(sys_in2[5]), .out2(sys_out2[5][0]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s51 (
		.in1(sys_out1[4][1]), .out1(sys_out1[5][1]), .in2(sys_out2[5][0]), .out2(sys_out2[5][1]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s52 (
		.in1(sys_out1[4][2]), .out1(sys_out1[5][2]), .in2(sys_out2[5][1]), .out2(sys_out2[5][2]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s53 (
		.in1(sys_out1[4][3]), .out1(sys_out1[5][3]), .in2(sys_out2[5][2]), .out2(sys_out2[5][3]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s54 (
		.in1(sys_out1[4][4]), .out1(sys_out1[5][4]), .in2(sys_out2[5][3]), .out2(sys_out2[5][4]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s55 (
		.in1(sys_out1[4][5]), .out1(sys_out1[5][5]), .in2(sys_out2[5][4]), .out2(sys_out2[5][5]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s56 (
		.in1(sys_out1[4][6]), .out1(sys_out1[5][6]), .in2(sys_out2[5][5]), .out2(sys_out2[5][6]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s57 (
		.in1(sys_out1[4][7]), .out1(sys_out1[5][7]), .in2(sys_out2[5][6]), .out2(sys_out2[5][7]), .readout(readout), .clk(clk), .reset(reset)
	);

	systolic_cell s60 (
		.in1(sys_out1[5][0]), .out1(sys_out1[6][0]), .in2(sys_in2[6]), .out2(sys_out2[6][0]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s61 (
		.in1(sys_out1[5][1]), .out1(sys_out1[6][1]), .in2(sys_out2[6][0]), .out2(sys_out2[6][1]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s62 (
		.in1(sys_out1[5][2]), .out1(sys_out1[6][2]), .in2(sys_out2[6][1]), .out2(sys_out2[6][2]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s63 (
		.in1(sys_out1[5][3]), .out1(sys_out1[6][3]), .in2(sys_out2[6][2]), .out2(sys_out2[6][3]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s64 (
		.in1(sys_out1[5][4]), .out1(sys_out1[6][4]), .in2(sys_out2[6][3]), .out2(sys_out2[6][4]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s65 (
		.in1(sys_out1[5][5]), .out1(sys_out1[6][5]), .in2(sys_out2[6][4]), .out2(sys_out2[6][5]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s66 (
		.in1(sys_out1[5][6]), .out1(sys_out1[6][6]), .in2(sys_out2[6][5]), .out2(sys_out2[6][6]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s67 (
		.in1(sys_out1[5][7]), .out1(sys_out1[6][7]), .in2(sys_out2[6][6]), .out2(sys_out2[6][7]), .readout(readout), .clk(clk), .reset(reset)
	);

	systolic_cell s70 (
		.in1(sys_out1[6][0]), .out1(sys_out1[7][0]), .in2(sys_in2[7]), .out2(sys_out2[7][0]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s71 (
		.in1(sys_out1[6][1]), .out1(sys_out1[7][1]), .in2(sys_out2[7][0]), .out2(sys_out2[7][1]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s72 (
		.in1(sys_out1[6][2]), .out1(sys_out1[7][2]), .in2(sys_out2[7][1]), .out2(sys_out2[7][2]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s73 (
		.in1(sys_out1[6][3]), .out1(sys_out1[7][3]), .in2(sys_out2[7][2]), .out2(sys_out2[7][3]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s74 (
		.in1(sys_out1[6][4]), .out1(sys_out1[7][4]), .in2(sys_out2[7][3]), .out2(sys_out2[7][4]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s75 (
		.in1(sys_out1[6][5]), .out1(sys_out1[7][5]), .in2(sys_out2[7][4]), .out2(sys_out2[7][5]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s76 (
		.in1(sys_out1[6][6]), .out1(sys_out1[7][6]), .in2(sys_out2[7][5]), .out2(sys_out2[7][6]), .readout(readout), .clk(clk), .reset(reset)
	);
	systolic_cell s77 (
		.in1(sys_out1[6][7]), .out1(sys_out1[7][7]), .in2(sys_out2[7][6]), .out2(sys_out2[7][7]), .readout(readout), .clk(clk), .reset(reset)
	);

	assign uo_out = readout ? sys_out1[7] : 8'b0;

	// generate
	// 	genvar j;
	// 	for (j=0; j<8; j++) begin : gen1
	// 		systolic_cell cell(
	// 			.in(ui_in[j]), .out(sys_out[0][j]), .readout(readout), .clk(clk), .reset(reset)
	// 		);
	// 	end
	// endgenerate

	// // generate
	// // 	genvar i;
	// // 	for (i=1; i<8; i++) begin : gen2
	// // 		genvar j;
	// // 		for (j=0; j<8; j++) begin : gen3
	// // 			systolic_cell cell(
	// // 				.in(sys_out[i-1][j]), .out(sys_out[i][j]), .readout(readout), .clk(clk), .reset(reset)
	// // 			);
	// // 		end
	// // 	end
	// // endgenerate

	// //for (int i=1; i<8; i++) 
	// //	for (int j=0; j<8; j++) 
	// //		systolic_cell(
	// //			sys_out[i-1][j], sys_out[i][j], clk
	// //		);

	// // assign uo_out = sys_out[7];
	// assign uo_out = sys_out[0];

	// // assign uo_out = sys_out;

endmodule


module systolic_cell (
	input wire in1,
	input wire in2,
	output reg out1,  // shouldn't this be wire? doesn't work if it is, though
	output reg out2,  // shouldn't this be wire? doesn't work if it is, though
	input wire readout,
	input wire clk,
	input wire reset
	);

	reg acc;	

	always @(posedge clk)
		if (reset) begin
            acc <= 0;
        	out1 <= 0;
        	out1 <= 0;
       	end else if (readout) begin
       		acc <= in1;
       		out1 <= acc;
       		out2 <= 1'b0;
        end else begin
			acc <= acc | (in1 & in2);
			out1 <= in1;
			out2 <= in2;
		end

endmodule



// ALU logic: 1, 2, 4, 8 bits for N (no negativity) with +, x with modulo, saturating, tropical

// start w/ 8x8 1bit example
// in/out just TSU

// one unit, into 8x8, systolic

// start with just shift registers
