

# for i in range(8):
# 	for j in range(8):
# 		if i == 0 and j == 0:
# 			print("""systolic_cell s00 (
# 	.in1(ui_in[0]), .out1(sys_out1[0][0]), .in2(ui_in[0]), .out2(sys_out2[0][0]), .readout(readout), .clk(clk), .reset(reset)
# );""")
# 		elif i != 0 and j == 0:
# 			print(f"""systolic_cell s{i}0 (
# 	.in1(sys_out1[{i-1}][0]), .out1(sys_out1[{i}][0]), .in2(ui_in[{i}]), .out2(sys_out2[{i}][0]), .readout(readout), .clk(clk), .reset(reset)
# );""")
# 		elif i == 0 and j != 0:
# 			print(f"""systolic_cell s0{j} (
# 	.in1(ui_in[{j}]), .out1(sys_out1[0][{j}]), .in2(sys_out2[0][{j-1}]), .out2(sys_out2[0][{j}]), .readout(readout), .clk(clk), .reset(reset)
# );""")
# 		else:
# 			print(f"""systolic_cell s{i}{j} (
# 	.in1(sys_out1[{i-1}][{j}]), .out1(sys_out1[{i}][{j}]), .in2(sys_out2[{i}][{j-1}]), .out2(sys_out2[{i}][{j}]), .readout(readout), .clk(clk), .reset(reset)
# );""")
# 	print()

# print()
# for i in range(8):
# 	print(f"assign sys_out[{i}] = sys_out1[{i}] & sys_out2[{i}];")

var = 'hi_out'
text = "\x00\x00\x00I am Probot!\x00"


for idx, ch in enumerate(text):
	print(f"4'b{idx:04b} : {var} = {ord(ch)};")



# initial 
strings = [
	"\x00",
	"Do you enter the tavern?\x00",
	"It's your party, you win!\x00",
	"A single tear falls from your face. You walk away and whisper: ",
	"I am Probot.\x00",
]
start = 0
for idx, string in enumerate(strings):
	print(f"[idx] start={start}: \"{string}\"")
	start += len(string)

k = 7
var = 'text_out'
text = "".join(strings)

print(f"Total length: {len(text)}")
assert len(text) <= 2**k

for idx, ch in enumerate(text):
	print(f"7'b{idx:07b} : {var} = {ord(ch)};")

print("====")
for ch in text:
	print(f"{ord(ch):07b}")

