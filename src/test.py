import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

import numpy as np


async def do_test_mult(in_1, in_2, dut, usexor=False):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    raw_correct_out = np.matmul(in_1, in_2)
    if usexor:
        correct_out = raw_correct_out % 2
    else:
        correct_out = np.minimum(raw_correct_out, 1)

    #            in_2_feed
    #               |
    #               V
    # in_1_feed -> out

    in_1_feed = np.zeros((8, 16), dtype=np.int32)
    in_2_feed = np.zeros((16, 8), dtype=np.int32)

    # in1 feeds in rows spread out through time, delayed by row index
    # in2 feeds in cols spread through time, delayed by col index
    # these temporally spread out things will interact and multiply

    # multiplying rows of in_1 by cols of in_2
    # with deeper rows/cols delayed
    for i in range(8):
        in_1_feed[i,i:i+8] = in_1[i]   # ith row of in_1
        in_2_feed[i:i+8,i] = in_2[:,i] # ith col of in_2

    print("correct_out")
    print(correct_out)    
    print("in_1")
    print(in_1)
    print("in_1_feed")
    print(in_1_feed)
    print("in_2")
    print(in_2)
    print("in_2_feed")
    print(in_2_feed)

    # reset
    dut._log.info("reset")
    dut.ena.value = 1
    dut.rst_n.value = 0
    #dut.readout.value = 0
    
    if usexor:
        dut.uio_in.value = 0x04  # usexor=1
    else:
        dut.uio_in.value = 0x00  # usexor=0

    
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    for i in range(32):   
        if i % 2 == 0:
            bits = reversed(list(in_1_feed[:, i // 2]))
        else:
            bits = reversed(list(in_2_feed[i // 2, :]))

        value = 0
        for b in bits:
            value = 2*value + int(b)
        dut.ui_in.value = value
        
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] value of uo_out {dut.uo_out.value} ui_in {dut.ui_in.value}")

    await ClockCycles(dut.clk, 16)  # what's minimal time to propagate?

    dut.uio_in.value = 0x02  # readout=1

    out_columns = []
    for i in range(16):
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] integer of uo_out {dut.uo_out.value}")
        out_columns.append([int(x) for x in dut.uo_out.value])

        if i == 0 or i > 9:
            assert dut.uo_out.value == 0

    out_matrix = np.array(out_columns[1:9], dtype=np.int32)[::-1,::-1].T

    print("out_matrix")
    print(out_matrix)
    print("correct_out")
    print(correct_out)
    print("raw_correct_out")
    print(raw_correct_out)

    np.testing.assert_equal(out_matrix, correct_out)


@cocotb.test()
async def test_mult_ident(dut):
    in_1 = np.eye(8, dtype=np.int32)
    in_2 = np.eye(8, dtype=np.int32)
    await do_test_mult(in_1, in_2, dut, usexor=False)
    

@cocotb.test()
async def test_mult_ident_xor(dut):
    in_1 = np.eye(8, dtype=np.int32)
    in_2 = np.eye(8, dtype=np.int32)
    await do_test_mult(in_1, in_2, dut, usexor=True)
    

@cocotb.test()
async def test_mult_perm(dut):
    in_1 = np.array([
        [0, 1, 0, 0, 0, 0, 0, 0],
        [1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
    ], dtype=np.int32)
    in_2 = np.array([
        [0, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0],
        [1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
    ], dtype=np.int32)
    await do_test_mult(in_1, in_2, dut, usexor=False)


@cocotb.test()
async def test_mult_perm_xor(dut):
    in_1 = np.array([
        [0, 1, 0, 0, 0, 0, 0, 0],
        [1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
    ], dtype=np.int32)
    in_2 = np.array([
        [0, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0],
        [1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
    ], dtype=np.int32)
    await do_test_mult(in_1, in_2, dut, usexor=True)



@cocotb.test()
async def test_mult(dut):
    in_1 = np.array([
        [0, 0, 1, 0, 0, 0, 1, 0],
        [0, 0, 1, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 0, 0, 1],
        [0, 1, 0, 0, 0, 0, 0, 1],
    ], dtype=np.int32)
    in_2 = np.array([
        [0, 0, 1, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 0, 0, 1],
        [0, 1, 0, 0, 0, 0, 0, 1],
    ], dtype=np.int32)    
    await do_test_mult(in_1, in_2, dut, usexor=False)


@cocotb.test()
async def test_mult_xor(dut):
    in_1 = np.array([
        [0, 0, 1, 0, 0, 0, 1, 0],
        [0, 0, 1, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 0, 0, 1],
        [0, 1, 0, 0, 0, 0, 0, 1],
    ], dtype=np.int32)
    in_2 = np.array([
        [0, 0, 1, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 0, 0, 1],
        [0, 1, 0, 0, 0, 0, 0, 1],
    ], dtype=np.int32)    
    await do_test_mult(in_1, in_2, dut, usexor=True)


@cocotb.test()
async def test_sayhi(dut):
    SAYHI = "I am Probot.\x00"
    
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # reset
    dut._log.info("reset")
    dut.ena.value = 1
    dut.rst_n.value = 0
    dut.uio_in.value = 0x00
    
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut.uio_in.value = 0x01  # sayhi=1
    await ClockCycles(dut.clk, 2)
    dut.uio_in.value = 0x00  # sayhi=0

    for i in range(60):        
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] value of uo_out {dut.uo_out.value} {chr(dut.uo_out.value.integer)}")
        assert dut.uo_out.value.integer == ord(SAYHI[min(i, len(SAYHI)-1)])


    # "Do you enter the tavern?\x00",
    # "It's your party, you win!\x00",
    # "A single tear falls from your face. You walk away and whisper: ",
    # "I am Probot.\x00",

    # wire start_adventure = uio_in[3];
    # wire answer_no = uio_in[4];
    # wire answer_yes = uio_in[5];

START_ADVENTURE = "Do you enter the tavern?\x00"
ANSWER_YES = "It's your party, you win!\x00"
ANSWER_NO = "A single tear falls from your face. You walk away and whisper: I am Probot.\x00"

@cocotb.test()
async def test_adventure_no(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # reset
    dut._log.info("reset")
    dut.ena.value = 1
    dut.rst_n.value = 0
    dut.uio_in.value = 0x00
    
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("answer_no")
    dut.uio_in.value = 0x10  # answer_no=1
    await ClockCycles(dut.clk, 2)
    dut.uio_in.value = 0x00  # answer_no=0

    for i in range(20):        
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] value of uo_out {dut.uo_out.value} {chr(dut.uo_out.value.integer)}")
        assert dut.uo_out.value.integer == 0    

    dut._log.info("start_adventure")
    dut.uio_in.value = 0x08  # start_adventure=1
    await ClockCycles(dut.clk, 2)
    dut.uio_in.value = 0x00  # start_adventure=0

    for i in range(30):        
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] value of uo_out {dut.uo_out.value} {chr(dut.uo_out.value.integer)}")
        assert dut.uo_out.value.integer == ord(START_ADVENTURE[min(i, len(START_ADVENTURE)-1)])

    dut._log.info("answer_no")
    dut.uio_in.value = 0x10  # answer_no=1
    await ClockCycles(dut.clk, 2)
    dut.uio_in.value = 0x00  # answer_no=0

    for i in range(100):
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] value of uo_out {dut.uo_out.value} {chr(dut.uo_out.value.integer)}")
        assert dut.uo_out.value.integer == ord(ANSWER_NO[min(i, len(ANSWER_NO)-1)])

    dut._log.info("answer_no")
    dut.uio_in.value = 0x10  # answer_no=1
    await ClockCycles(dut.clk, 2)
    dut.uio_in.value = 0x00  # answer_no=0

    for i in range(20):        
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] value of uo_out {dut.uo_out.value} {chr(dut.uo_out.value.integer)}")
        assert dut.uo_out.value.integer == 0



@cocotb.test()
async def test_adventure_yes(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # reset
    dut._log.info("reset")
    dut.ena.value = 1
    dut.rst_n.value = 0
    dut.uio_in.value = 0x00
    
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("answer_yes")
    dut.uio_in.value = 0x20  # answer_yes=1
    await ClockCycles(dut.clk, 2)
    dut.uio_in.value = 0x00  # answer_yes=0

    for i in range(20):        
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] value of uo_out {dut.uo_out.value} {chr(dut.uo_out.value.integer)}")
        assert dut.uo_out.value.integer == 0    

    dut._log.info("start_adventure")
    dut.uio_in.value = 0x08  # start_adventure=1
    await ClockCycles(dut.clk, 2)
    dut.uio_in.value = 0x00  # start_adventure=0

    for i in range(30):        
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] value of uo_out {dut.uo_out.value} {chr(dut.uo_out.value.integer)}")
        assert dut.uo_out.value.integer == ord(START_ADVENTURE[min(i, len(START_ADVENTURE)-1)])

    dut._log.info("answer_yes")
    dut.uio_in.value = 0x20  # answer_yes=1
    await ClockCycles(dut.clk, 2)
    dut.uio_in.value = 0x00  # answer_yes=0

    for i in range(100):
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] value of uo_out {dut.uo_out.value} {chr(dut.uo_out.value.integer)}")
        assert dut.uo_out.value.integer == ord(ANSWER_YES[min(i, len(ANSWER_YES)-1)])

    dut._log.info("answer_yes")
    dut.uio_in.value = 0x20  # answer_yes=1
    await ClockCycles(dut.clk, 2)
    dut.uio_in.value = 0x00  # answer_yes=0

    for i in range(20):        
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] value of uo_out {dut.uo_out.value} {chr(dut.uo_out.value.integer)}")
        assert dut.uo_out.value.integer == 0