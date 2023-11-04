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

	wire reset = !rst_n | !ena;
	wire sayhi = uio_in[0];
	wire readout = uio_in[1];
	wire usexor = uio_in[2];
    wire start_adventure = uio_in[3];
    wire answer_no = uio_in[4];
    wire answer_yes = uio_in[5];

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

		// $display("main reset %b readout %b sys_in1 %b sys_in1_buffer %b sys_in2 %b sys_in1_next %b sys_in_valid %b usexor %b", reset, readout, sys_in1, sys_in1_buffer, sys_in2, sys_in1_next, sys_in_valid, usexor);		
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

	reg [6:0] text_idx;
	reg [7:0] text_out;

    always @*
    	case (text_idx)
	 	    7'b0000000 : text_out = 0;
			7'b0000001 : text_out = 68;
			7'b0000010 : text_out = 111;
			7'b0000011 : text_out = 32;
			7'b0000100 : text_out = 121;
			7'b0000101 : text_out = 111;
			7'b0000110 : text_out = 117;
			7'b0000111 : text_out = 32;
			7'b0001000 : text_out = 101;
			7'b0001001 : text_out = 110;
			7'b0001010 : text_out = 116;
			7'b0001011 : text_out = 101;
			7'b0001100 : text_out = 114;
			7'b0001101 : text_out = 32;
			7'b0001110 : text_out = 116;
			7'b0001111 : text_out = 104;
			7'b0010000 : text_out = 101;
			7'b0010001 : text_out = 32;
			7'b0010010 : text_out = 116;
			7'b0010011 : text_out = 97;
			7'b0010100 : text_out = 118;
			7'b0010101 : text_out = 101;
			7'b0010110 : text_out = 114;
			7'b0010111 : text_out = 110;
			7'b0011000 : text_out = 63;
			7'b0011001 : text_out = 0;
			7'b0011010 : text_out = 73;
			7'b0011011 : text_out = 116;
			7'b0011100 : text_out = 39;
			7'b0011101 : text_out = 115;
			7'b0011110 : text_out = 32;
			7'b0011111 : text_out = 121;
			7'b0100000 : text_out = 111;
			7'b0100001 : text_out = 117;
			7'b0100010 : text_out = 114;
			7'b0100011 : text_out = 32;
			7'b0100100 : text_out = 112;
			7'b0100101 : text_out = 97;
			7'b0100110 : text_out = 114;
			7'b0100111 : text_out = 116;
			7'b0101000 : text_out = 121;
			7'b0101001 : text_out = 44;
			7'b0101010 : text_out = 32;
			7'b0101011 : text_out = 121;
			7'b0101100 : text_out = 111;
			7'b0101101 : text_out = 117;
			7'b0101110 : text_out = 32;
			7'b0101111 : text_out = 119;
			7'b0110000 : text_out = 105;
			7'b0110001 : text_out = 110;
			7'b0110010 : text_out = 33;
			7'b0110011 : text_out = 0;
			7'b0110100 : text_out = 65;
			7'b0110101 : text_out = 32;
			7'b0110110 : text_out = 115;
			7'b0110111 : text_out = 105;
			7'b0111000 : text_out = 110;
			7'b0111001 : text_out = 103;
			7'b0111010 : text_out = 108;
			7'b0111011 : text_out = 101;
			7'b0111100 : text_out = 32;
			7'b0111101 : text_out = 116;
			7'b0111110 : text_out = 101;
			7'b0111111 : text_out = 97;
			7'b1000000 : text_out = 114;
			7'b1000001 : text_out = 32;
			7'b1000010 : text_out = 102;
			7'b1000011 : text_out = 97;
			7'b1000100 : text_out = 108;
			7'b1000101 : text_out = 108;
			7'b1000110 : text_out = 115;
			7'b1000111 : text_out = 32;
			7'b1001000 : text_out = 102;
			7'b1001001 : text_out = 114;
			7'b1001010 : text_out = 111;
			7'b1001011 : text_out = 109;
			7'b1001100 : text_out = 32;
			7'b1001101 : text_out = 121;
			7'b1001110 : text_out = 111;
			7'b1001111 : text_out = 117;
			7'b1010000 : text_out = 114;
			7'b1010001 : text_out = 32;
			7'b1010010 : text_out = 102;
			7'b1010011 : text_out = 97;
			7'b1010100 : text_out = 99;
			7'b1010101 : text_out = 101;
			7'b1010110 : text_out = 46;
			7'b1010111 : text_out = 32;
			7'b1011000 : text_out = 89;
			7'b1011001 : text_out = 111;
			7'b1011010 : text_out = 117;
			7'b1011011 : text_out = 32;
			7'b1011100 : text_out = 119;
			7'b1011101 : text_out = 97;
			7'b1011110 : text_out = 108;
			7'b1011111 : text_out = 107;
			7'b1100000 : text_out = 32;
			7'b1100001 : text_out = 97;
			7'b1100010 : text_out = 119;
			7'b1100011 : text_out = 97;
			7'b1100100 : text_out = 121;
			7'b1100101 : text_out = 32;
			7'b1100110 : text_out = 97;
			7'b1100111 : text_out = 110;
			7'b1101000 : text_out = 100;
			7'b1101001 : text_out = 32;
			7'b1101010 : text_out = 119;
			7'b1101011 : text_out = 104;
			7'b1101100 : text_out = 105;
			7'b1101101 : text_out = 115;
			7'b1101110 : text_out = 112;
			7'b1101111 : text_out = 101;
			7'b1110000 : text_out = 114;
			7'b1110001 : text_out = 58;
			7'b1110010 : text_out = 32;
			7'b1110011 : text_out = 73;
			7'b1110100 : text_out = 32;
			7'b1110101 : text_out = 97;
			7'b1110110 : text_out = 109;
			7'b1110111 : text_out = 32;
			7'b1111000 : text_out = 80;
			7'b1111001 : text_out = 114;
			7'b1111010 : text_out = 111;
			7'b1111011 : text_out = 98;
			7'b1111100 : text_out = 111;
			7'b1111101 : text_out = 116;
			7'b1111110 : text_out = 46;
			7'b1111111 : text_out = 0;
		endcase


	reg adventure_running;

	always @(posedge clk) begin
//		$display("adventure_running %b", adventure_running);
		if (reset) begin
//			$display("T reset");
			text_idx <= 0;
			adventure_running <= 0;
		end else if (sayhi) begin
//			$display("T sayhi");
			text_idx <= 115;
			adventure_running <= 0;
		end else if (start_adventure) begin
//			$display("T start_adventure");		
			text_idx <= 1;
			adventure_running <= 1;
		end else if (answer_yes) begin
//			$display("T answer_yes");		
			text_idx <= adventure_running ? 26 : text_idx;
			adventure_running <= 0;
		end else if (answer_no) begin
//			$display("T answer_no");		
			text_idx <= adventure_running ? 52 : text_idx;
			adventure_running <= 0;
		end else if (text_idx > 0) begin
//			$display("T advance text %b", text_idx);
			if (text_out == 0)
				text_idx <= text_idx;
			else
				text_idx <= (text_idx + 1'b1);  // implicit wrap?
		end else begin
//			$display("T else");
			adventure_running <= 0;
			text_idx <= 0;
		end
	end

	assign uo_out = text_idx > 0 ? text_out : sys_out;

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

		// $display("%m reset %b usexor %b readout %b in1 %b in2 %b acc %b out1 %b out2 %b", reset, readout, usexor, in1, in2, acc, out1, out2);
	end


endmodule

