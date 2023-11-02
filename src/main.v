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
	wire usexor = uio_in[1];
	wire sayhi = uio_in[7];

	// defaults
	assign uio_oe = 8'b0;
	assign uio_out = 8'b0;

	wire [7:0] sys_in1;
	wire [7:0] sys_in2;
	reg [7:0] sys_in1_buffer;
	reg sys_in1_next;
	wire sys_in_valid;

	assign sys_in_valid = (!reset && !readout && !sys_in1_next);
	assign sys_in1 = sys_in_valid ? sys_in1_buffer : 8'b0;
	assign sys_in2 = sys_in_valid ? ui_in : 8'b0;

	always @(posedge clk) begin
		if (reset || readout) begin
			sys_in1_buffer <= 8'b0;
			sys_in1_next <= 1'b1;
		end else if (sys_in1_next) begin
			sys_in1_buffer <= ui_in;
			sys_in1_next <= 1'b0;
		end else begin
			sys_in1_buffer <= 8'b0;
			sys_in1_next <= 1'b1;
		end

		$display("main reset %b readout %b sys_in1 %b sys_in1_buffer %b sys_in2 %b sys_in1_next %b sys_in_valid %b", reset, readout, sys_in1, sys_in1_buffer, sys_in2, sys_in1_next, sys_in_valid);		
	end

	// parameter N = 2;
	// parameter N = 4;
	parameter N = 8;

	// wire [7:0] sys_out;
	wire [N-1:0] sys_out;
	systolic_array #(.N(N)) sa (
		.clk(clk),
		.readout(readout),
		.reset(reset),
		.in1(sys_in1[N-1:0]),
		.in2(sys_in2[N-1:0]),
		.out(sys_out),
		.usexor(usexor),
		.sys_in_valid(sys_in_valid)
	);

	reg [7:0] hi_out;
	reg [3:0] hi_idx;

	always @*
		case(hi_idx)
			4'b0000 : hi_out = 0;
			4'b0001 : hi_out = 0;
			4'b0010 : hi_out = 0;
			4'b0011 : hi_out = "I";
			4'b0100 : hi_out = " ";
			4'b0101 : hi_out = "a";
			4'b0110 : hi_out = "m";
			4'b0111 : hi_out = " ";
			4'b1000 : hi_out = "P";
			4'b1001 : hi_out = "r";
			4'b1010 : hi_out = "o";
			4'b1011 : hi_out = "b";
			4'b1100 : hi_out = "o";
			4'b1101 : hi_out = "t";
			4'b1110 : hi_out = "!";
			4'b1111 : hi_out = 0;
		endcase	

	always @(posedge clk)
		if (sayhi) begin
			hi_idx <= (hi_idx + 1'b1) % 16;  // or [0:3] ??
		end else begin
			hi_idx <= 0;
		end

	assign uo_out = sayhi ? hi_out : sys_out;

endmodule


module systolic_array #(parameter N = 8)
(
	input clk, readout, reset, usexor, sys_in_valid,
	input [N-1:0] in1,
	input [N-1:0] in2,
	output [N-1:0] out
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
					.in1(sys_out1[i][j]), .out1(sys_out1[i+1][j]), .in2(sys_out2[j][i]), .out2(sys_out2[j+1][i]), .readout(readout), .clk(clk), .reset(reset), .usexor(usexor), .sys_in_valid(sys_in_valid)
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
	output reg out1,
	output reg out2,
	input wire readout,
	input wire clk,
	input wire reset,
	input wire usexor,
	input wire sys_in_valid
	);

	reg acc;

	always @(posedge clk) begin
		// in1_and_in2 = in1 & in2

		if (reset) begin
            acc <= 0;
            out1 <= 0;
            out2 <= 0;
       	end else if (readout) begin
       		// assuming in1 is all zero before first readout step,
       		// this will have out1 <= acc, and at all other steps
       		// successive out1's will form shift registers
       		acc <= 0;
            out1 <= in1 | acc; 
            out2 <= 0;
        end else if (sys_in_valid) begin
			acc <= usexor ? (acc ^ (in1 & in2)) : (acc | (in1 & in2));
            out1 <= in1;
            out2 <= in2;
		end else begin
			acc <= acc;
            out1 <= out1;
            out2 <= out2;
        end

		//$display("%m reset %b readout %b in1 %b in2 %b acc %b out1 %b out2 %b", reset, readout, in1, in2, acc, out1, out2);
	end


endmodule



// ALU logic: 1, 2, 4, 8 bits for N (no negativity) with +, x with modulo, saturating, tropical

// start w/ 8x8 1bit example
// in/out just TSU

