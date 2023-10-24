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

	wire reset = !rst_n | !ena;
	wire readout = uio_in[0];

	// defaults
	assign uio_oe = 8'b0;
	assign uio_out = 8'b0;

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

	wire [7:0] sys_out;
	systolic_array #(.N(8)) sa (
		.clk(clk),
		.readout(readout),
		.reset(reset),
		.in1(sys_in1),
		.in2(sys_in2),
		.out(sys_out)
	);

	assign uo_out = sys_out;

endmodule


module systolic_array #(parameter N = 8)
(
	input clk, readout, reset,
	input [N-1:0] in1,
	input [N-1:0] in2,
	output [N-1:0] out,
);
	genvar i;
	genvar j;

	wire [N-1:0] sys_out1[N:0];
	wire [N-1:0] sys_out2[N:0];

	assign sys_out1[0] = in1;
	assign sys_out2[0] = in2;

	// TODO: can we give placement hints to have this be grid-like??
	generate
		for (i = 0; i < N; i++) begin : iloop
			for (j = 0; j < N; j++) begin : jloop
				systolic_cell sxy (
					.in1(sys_out1[i][j]), .out1(sys_out1[i+1][j]), .in2(sys_out2[j][i]), .out2(sys_out2[j+1][i]), .readout(readout), .clk(clk), .reset(reset)
				);
				// TODO: flip i, j for out1 vs out2? write out coords correctly as or [x][y]?
			end
		end
	endgenerate

	assign out = readout ? sys_out1[N] : 0;

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

