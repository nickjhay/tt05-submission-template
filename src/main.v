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

	wire [7:0] sys_out[0:7];

	for (int j=0; j<8; j++) 
		systolic_cell(
			ui_in[j], sys_out[0][j], clk
		);

	for (int i=1; i<8; i++) 
		for (int j=0; j<8; j++) 
			systolic_cell(
				sys_out[i-1][j], sys_out[i][j], clk
			);

	uo_out <= sys_out[7];

endmodule


module systolic_cell (
	input wire in,
	output wire out,
	input wire clk,
	);

	reg acc;

	always @(posedge clk) begin
		out <= acc;
		acc <= in;
	end

endmodule



// ALU logic: 1, 2, 4, 8 bits for N (no negativity) with +, x with modulo, saturating, tropical

// start w/ 8x8 1bit example
// in/out just TSU

// one unit, into 8x8, systolic

// start with just shift registers
