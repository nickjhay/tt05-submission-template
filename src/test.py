import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

import numpy as np

# @cocotb.test()
# async def test_mult1(dut):
#     dut._log.info("start")
#     clock = Clock(dut.clk, 10, units="us")
#     cocotb.start_soon(clock.start())

#     ident = np.array([
#         [1, 0, 0, 0, 0, 0, 0, 0],
#         [0, 1, 0, 0, 0, 0, 0, 0],
#         [0, 0, 1, 0, 0, 0, 0, 0],
#         [0, 0, 0, 1, 0, 0, 0, 0],
#         [0, 0, 0, 0, 1, 0, 0, 0],
#         [0, 0, 0, 0, 0, 1, 0, 0],
#         [0, 0, 0, 0, 0, 0, 1, 0],
#         [0, 0, 0, 0, 0, 0, 0, 1],
#     ], dtype=np.int32)
#     in_1 = ident
#     in_2 = ident
#     out = ident

#     # in_1 = np.array([
#     #     [0, 0, 1, 0, 0, 0, 1, 0],
#     #     [0, 0, 1, 0, 0, 0, 1, 0],
#     #     [0, 0, 0, 0, 0, 0, 0, 0],
#     #     [0, 0, 0, 0, 0, 0, 0, 0],
#     #     [0, 1, 0, 0, 0, 0, 1, 1],
#     #     [0, 1, 0, 0, 0, 0, 1, 1],
#     #     [0, 1, 0, 0, 0, 0, 0, 1],
#     #     [0, 1, 0, 0, 0, 0, 0, 1],
#     # ], dtype=np.int32)
#     # in_2 = np.array([
#     #     [0, 0, 1, 0, 0, 0, 1, 0],
#     #     [0, 0, 0, 0, 0, 0, 0, 0],
#     #     [0, 0, 1, 0, 0, 0, 1, 0],
#     #     [0, 0, 0, 0, 0, 0, 0, 0],
#     #     [0, 1, 0, 0, 0, 0, 1, 1],
#     #     [0, 1, 0, 0, 0, 0, 1, 1],
#     #     [0, 1, 0, 0, 0, 0, 0, 1],
#     #     [0, 1, 0, 0, 0, 0, 0, 1],
#     # ], dtype=np.int32)

#     # out = np.minimum(np.matmul(in_a, in_b), 1)
#     # out = np.matmul(in_a, in_b) % 2  <-- for xor

#     #            in_2_feed
#     #               |
#     #               V
#     # in_1_feed -> out

#     in_1_feed = np.zeros((8, 16), dtype=np.int32)
#     in_2_feed = np.zeros((16, 8), dtype=np.int32)

#     # multiplying rows of in_1 by cols of in_2
#     # with deeper rows/cols delayed
#     for i in range(8):
#         in_1_feed[i,i:i+8] = in_1[i]   # ith row of in_1
#         in_2_feed[i:i+8,i] = in_2[:,i] # ith col of in_2

#     print(in_1_feed)
#     print(in_2_feed)


#     # reset
#     dut._log.info("reset")
#     dut.ena.value = 1
#     dut.rst_n.value = 0
#     #dut.readout.value = 0
#     dut.uio_in.value = 0x00
    
#     await ClockCycles(dut.clk, 10)
#     dut.rst_n.value = 1


#     for i in range(32):   
#         # if i == 0:
#             # set input values: 1001 0011
#             # dut.ui_in.value = 0x93
#         # else:
#             # dut.ui_in.value = 0     
#         if i % 2 == 0:
#             bits = list(in_1_feed[:, i // 2])
#         else:
#             bits = list(in_2_feed[i // 2, :])

#         # TODO: lsb or msb?

#         value = 0
#         for b in bits:
#             value = 2*value + int(b)
#         dut.ui_in.value = value
        
#         await ClockCycles(dut.clk, 1)
#         dut._log.info(f"[{i}] value of uo_out {dut.uo_out.value} ui_in {dut.ui_in.value}\n")

#     await ClockCycles(dut.clk, 8)  # enough time to propagate?

#     # dut.readout.value = 1
#     dut.uio_in.value = 0x01

#     outs = []
#     for i in range(16):
#         await ClockCycles(dut.clk, 1)
#         dut._log.info(f"[{i}] integer of uo_out {dut.uo_out.value}\n")
#         outs.append(dut.uo_out.value)

#     print(outs)

#     # # the compare integer is shifted 10 bits inside the design to allow slower counting
#     # max_count = dut.ui_in.value << 10
#     # dut._log.info(f"check all segments with MAX_COUNT set to {max_count}")
#     # # check all segments and roll over
#     # for i in range(15):
#     #     dut._log.info("check segment {}".format(i))
#     #     await ClockCycles(dut.clk, max_count)
#     #     assert int(dut.segments.value) == segments[i % 10]

#     #     # all bidirectionals are set to output
#     #     assert dut.uio_oe == 0xFF

#     # # reset
#     # dut.rst_n.value = 0
#     # # set a different compare value
#     # dut.ui_in.value = 3
#     # await ClockCycles(dut.clk, 10)
#     # dut.rst_n.value = 1

#     # max_count = dut.ui_in.value << 10
#     # dut._log.info(f"check all segments with MAX_COUNT set to {max_count}")
#     # # check all segments and roll over
#     # for i in range(15):
#     #     dut._log.info("check segment {}".format(i))
#     #     await ClockCycles(dut.clk, max_count)
#     #     assert int(dut.segments.value) == segments[i % 10]



@cocotb.test()
async def test_mult2(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # ident = np.array([
    #     [1, 0, 0, 0, 0, 0, 0, 0],
    #     [0, 1, 0, 0, 0, 0, 0, 0],
    #     [0, 0, 1, 0, 0, 0, 0, 0],
    #     [0, 0, 0, 1, 0, 0, 0, 0],
    #     [0, 0, 0, 0, 1, 0, 0, 0],
    #     [0, 0, 0, 0, 0, 1, 0, 0],
    #     [0, 0, 0, 0, 0, 0, 1, 0],
    #     [0, 0, 0, 0, 0, 0, 0, 1],
    # ], dtype=np.int32)
    # in_1 = ident
    # in_2 = ident
    # out = ident    

    # in_1 = np.array([
    #     [0, 0, 1, 0, 0, 0, 1, 0],
    #     [0, 0, 1, 0, 0, 0, 1, 0],
    #     [0, 0, 0, 0, 0, 0, 0, 0],
    #     [0, 0, 0, 0, 0, 0, 0, 0],
    #     [0, 1, 0, 0, 0, 0, 1, 1],
    #     [0, 1, 0, 0, 0, 0, 1, 1],
    #     [0, 1, 0, 0, 0, 0, 0, 1],
    #     [0, 1, 0, 0, 0, 0, 0, 1],
    # ], dtype=np.int32)
    # in_2 = np.array([
    #     [0, 0, 1, 0, 0, 0, 1, 0],
    #     [0, 0, 0, 0, 0, 0, 0, 0],
    #     [0, 0, 1, 0, 0, 0, 1, 0],
    #     [0, 0, 0, 0, 0, 0, 0, 0],
    #     [0, 1, 0, 0, 0, 0, 1, 1],
    #     [0, 1, 0, 0, 0, 0, 1, 1],
    #     [0, 1, 0, 0, 0, 0, 0, 1],
    #     [0, 1, 0, 0, 0, 0, 0, 1],
    # ], dtype=np.int32)

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

    # 0 0 0 1
    # 0 1 0 0
    # 1 0 0 0
    # 0 0 1 0  

    out = np.minimum(np.matmul(in_1, in_2), 1)

    print(out)
    
    # out = np.matmul(in_a, in_b) % 2  TODO: <-- for xor

    #            in_2_feed
    #               |
    #               V
    # in_1_feed -> out

    in_1_feed = np.zeros((8, 16), dtype=np.int32)
    in_2_feed = np.zeros((16, 8), dtype=np.int32)

    # multiplying rows of in_1 by cols of in_2
    # with deeper rows/cols delayed
    for i in range(8):
        in_1_feed[i,i:i+8] = in_1[i]   # ith row of in_1
        in_2_feed[i:i+8,i] = in_2[:,i] # ith col of in_2

    print(in_1_feed)
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
        # if i == 0:
            # set input values: 1001 0011
            # dut.ui_in.value = 0x93
        # else:
            # dut.ui_in.value = 0     
        if i % 2 == 0:
            bits = list(in_1_feed[:, i // 2])
        else:
            bits = list(in_2_feed[i // 2, :])

        # TODO: lsb or msb?

        value = 0
        for b in bits:
            value = 2*value + int(b)
        dut.ui_in.value = value
        
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] value of uo_out {dut.uo_out.value} ui_in {dut.ui_in.value}\n")

    await ClockCycles(dut.clk, 16)  # what's minimal time to propagate?

    # dut.readout.value = 1
    dut.uio_in.value = 0x01  # readout=1

    outs = []
    for i in range(16):
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] integer of uo_out {dut.uo_out.value}\n")
        outs.append(dut.uo_out.value)

    print(outs)

    # # the compare integer is shifted 10 bits inside the design to allow slower counting
    # max_count = dut.ui_in.value << 10
    # dut._log.info(f"check all segments with MAX_COUNT set to {max_count}")
    # # check all segments and roll over
    # for i in range(15):
    #     dut._log.info("check segment {}".format(i))
    #     await ClockCycles(dut.clk, max_count)
    #     assert int(dut.segments.value) == segments[i % 10]

    #     # all bidirectionals are set to output
    #     assert dut.uio_oe == 0xFF

    # # reset
    # dut.rst_n.value = 0
    # # set a different compare value
    # dut.ui_in.value = 3
    # await ClockCycles(dut.clk, 10)
    # dut.rst_n.value = 1

    # max_count = dut.ui_in.value << 10
    # dut._log.info(f"check all segments with MAX_COUNT set to {max_count}")
    # # check all segments and roll over
    # for i in range(15):
    #     dut._log.info("check segment {}".format(i))
    #     await ClockCycles(dut.clk, max_count)
    #     assert int(dut.segments.value) == segments[i % 10]

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

    dut.uio_in.value = 0x80  # sayhi=1

    for i in range(60):        
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"[{i}] value of uo_out {dut.uo_out.value}\n")
        assert dut.uo_out.value.integer == ord(SAYHI[i%16])

