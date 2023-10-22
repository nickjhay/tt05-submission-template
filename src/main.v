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

	wire [7:0] sys_out;

	systolic_cell s00 (
		.in(ui_in[0]), .out(sys_out[0]), .clk(clk), .reset(reset)
	);
	systolic_cell s01 (
		.in(ui_in[1]), .out(sys_out[1]), .clk(clk), .reset(reset)
	);
	systolic_cell s02 (
		.in(ui_in[2]), .out(sys_out[2]), .clk(clk), .reset(reset)
	);
	systolic_cell s03 (
		.in(ui_in[3]), .out(sys_out[3]), .clk(clk), .reset(reset)
	);
	systolic_cell s04 (
		.in(ui_in[4]), .out(sys_out[4]), .clk(clk), .reset(reset)
	);
	systolic_cell s05 (
		.in(ui_in[5]), .out(sys_out[5]), .clk(clk), .reset(reset)
	);
	systolic_cell s06 (
		.in(ui_in[6]), .out(sys_out[6]), .clk(clk), .reset(reset)
	);
	systolic_cell s07 (
		.in(ui_in[7]), .out(sys_out[7]), .clk(clk), .reset(reset)
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

	// assign uo_out = sys_out[7];

	assign uo_out = sys_out;

endmodule


module systolic_cell (
	input wire in,
	output wire out,
	input wire clk,
	input wire reset,
	);

	// need reset here??

	reg acc;

	assign out = acc;

	always @(posedge clk) begin
		if (reset)
            acc <= 0;
        else
			acc <= in;
		end
	end


endmodule



// ALU logic: 1, 2, 4, 8 bits for N (no negativity) with +, x with modulo, saturating, tropical

// start w/ 8x8 1bit example
// in/out just TSU

// one unit, into 8x8, systolic

// start with just shift registers
