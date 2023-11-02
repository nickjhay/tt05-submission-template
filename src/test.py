import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

import numpy as np


async def do_test_mult(in_1, in_2, dut, usexor=False):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    if usexor:
        correct_out = np.matmul(in_1, in_2) % 2
    else:
        correct_out = np.minimum(np.matmul(in_1, in_2), 1)

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
    dut.uio_in.value = 0x00
    
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


SAYHI = "\x00\x00\x00I am Probot!\x00"

@cocotb.test()
async def test_sayhi(dut):
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

    for i in range(60):        
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] value of uo_out {dut.uo_out.value}")
        assert dut.uo_out.value.integer == ord(SAYHI[i%16])

