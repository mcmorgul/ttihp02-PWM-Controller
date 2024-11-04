# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles
from cocotb.binary import BinaryValue

@cocotb.test()
async def test_pwm_with_reset_and_timing(dut):
    dut._log.info("Start")

    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut._log.info("PWM")
    dut.ena.value = 1
    dut.ui_in.value = 0b0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    await ClockCycles(dut.clk, 1)

    a = 0
    for i in range(10):
        await ClockCycles(dut.clk, 1)
        if(dut.uo_out[0].value == 1):
            a = a + 1
    assert a == 5

        

    dut.ui_in[0].value = 1

    b = 0
    for i in range(10):
        await ClockCycles(dut.clk, 1)
        dut.ui_in[0].value = 0
        if(dut.uo_out[0].value == 1):
            b = b + 1
    assert b == 6


    await ClockCycles(dut.clk, 10)

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 10)

    dut.ui_in[1].value = 1

    c = 0
    for i in range(10):
        await ClockCycles(dut.clk, 1)
        dut.ui_in[1].value = 0
        if(dut.uo_out[0].value == 1):
            c = c + 1
    assert c == 4


            

