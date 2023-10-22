

for i in range(8):
	for j in range(8):
		if i == 0 and j == 0:
			print("""systolic_cell s00 (
	.in1(ui_in[0]), .out1(sys_out1[0][0]), .in2(ui_in[0]), .out2(sys_out2[0][0]), .clk(clk), .reset(reset)
);""")
		elif i != 0 and j == 0:
			print(f"""systolic_cell s{i}0 (
	.in1(sys_out1[{i-1}][0]), .out1(sys_out1[{i}][0]), .in2(ui_in[{i}]), .out2(sys_out2[{i}][0]), .clk(clk), .reset(reset)
);""")
		elif i == 0 and j != 0:
			print(f"""systolic_cell s0{j} (
	.in1(ui_in[{j}]), .out1(sys_out1[0][{j}]), .in2(sys_out2[0][{j-1}]), .out2(sys_out2[0][{j}]), .clk(clk), .reset(reset)
);""")
		else:
			print(f"""systolic_cell s{i}{j} (
	.in1(sys_out1[{i-1}][{j}]), .out1(sys_out1[{i}][{j}]), .in2(sys_out2[{i}][{j-1}]), .out2(sys_out2[{i}][{j}]), .clk(clk), .reset(reset)
);""")
	print()

print()
for i in range(8):
	print(f"assign sys_out[{i}] = sys_out1[{i}] & sys_out2[{i}];")