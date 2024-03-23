from argparse import ArgumentParser
from pathlib import Path

import numpy as np
from amaranth import Module, Signal, signed
from amaranth.back import verilog
from amaranth.lib import wiring
from amaranth.lib.memory import Memory
from amaranth.lib.wiring import In, Out
from amaranth.sim import Simulator, Tick


def cordic(theta: np.ndarray, resolution: int, iterations: int):
    if resolution > 64:
        raise ValueError('Resolution must be less than 64')

    tans = np.power(2, -np.arange(iterations, dtype=np.float64))
    phis = np.arctan(tans)
    k = np.prod(np.cos(phis))
    mul = 2**(resolution - 2)
    tan_phis_fixed = (phis / np.pi * mul).astype(np.int64)
    theta_fixed = (theta / np.pi * mul).astype(np.int64)

    x = np.ones_like(theta_fixed) * int(mul * k)
    y = np.zeros_like(theta_fixed)
    t = np.zeros_like(theta_fixed)

    for i in range(iterations):
        sign = (theta_fixed > t) * 2 - 1
        xn = x - (y >> i) * sign
        yn = y + (x >> i) * sign
        x, y = xn, yn
        t = t + tan_phis_fixed[i] * sign

    return x / mul, y / mul


class CORDIC_SINE(wiring.Component):

    def __init__(self, resolution=32, iterations=20):
        self.resolution = resolution
        self.mul = 2**(self.resolution - 2)
        self._iterations = iterations
        super().__init__(
            {
                'enable': In(1),
                'valid': Out(1),
                'theta': In(signed(resolution)),
                'sine': Out(signed(resolution)),
                'cosine': Out(signed(resolution)),
            }
        )

    def elaborate(self, platform):
        tans = np.power(2, -np.arange(self._iterations, dtype=np.float64))
        # radians
        phis = np.arctan(tans)
        k = np.prod(np.cos(phis))
        tan_phis_fixed = (phis / np.pi * self.mul).astype(np.int64)

        m = Module()
        m.submodules.tan_phi = tan_phi_mem = Memory(
            shape=signed(self.resolution),
            depth=self._iterations,
            init=tan_phis_fixed,
        )
        x = Signal(signed(self.resolution))
        y = Signal(signed(self.resolution))
        phi = Signal(signed(self.resolution))
        iteration = Signal(range(self._iterations + 1))
        tan_phi_i = Signal(signed(self.resolution))
        read_port = tan_phi_mem.read_port(domain='comb')
        m.d.comb += [read_port.addr.eq(iteration), tan_phi_i.eq(read_port.data)]
        with m.FSM() as fsm:
            with m.State('idle'):
                with m.If(self.enable):
                    m.d.sync += x.eq(int(self.mul * k))
                    m.d.sync += y.eq(0)
                    m.d.sync += phi.eq(0)
                    m.d.sync += iteration.eq(0)
                    m.d.sync += self.valid.eq(0)
                    m.next = 'calculate'
            with m.State('calculate'):
                with m.If(iteration < self._iterations):
                    m.d.sync += iteration.eq(iteration + 1)
                with m.Else():
                    m.d.sync += self.sine.eq(y)
                    m.d.sync += self.cosine.eq(x)
                    m.d.sync += self.valid.eq(1)
                    m.next = 'idle'
                with m.If(phi < self.theta):
                    m.d.sync += x.eq(x - (y >> iteration))
                    m.d.sync += y.eq(y + (x >> iteration))
                    m.d.sync += phi.eq(phi + tan_phi_i)
                with m.Else():
                    m.d.sync += x.eq(x + (y >> iteration))
                    m.d.sync += y.eq(y - (x >> iteration))
                    m.d.sync += phi.eq(phi - tan_phi_i)

        return m


def get_args():
    parser = ArgumentParser()
    parser.add_argument('--resolution', type=int, default=32)
    parser.add_argument('--iterations', type=int, default=20)
    parser.add_argument('--sim', action='store_true')
    parser.add_argument('--verilog', action='store_true')
    parser.add_argument('--output', type=Path, default=Path('build/cordic.v'))
    return parser.parse_args()


args = get_args()

args.resolution = args.resolution
args.iterations = args.iterations
dut = CORDIC_SINE(resolution=args.resolution, iterations=args.iterations)

if args.sim:
    sim = Simulator(dut)
    sim.add_clock(1e-6)

    def bench():
        for i in range(3):
            yield Tick()
        test_thetas = np.linspace(-np.pi / 2, np.pi / 2, 100)
        answers_cos, answers_sin = cordic(
            test_thetas,
            resolution=args.resolution,
            iterations=args.iterations,
        )
        for theta, ans_x, ans_y in zip(test_thetas, answers_cos, answers_sin):
            yield dut.theta.eq(int(theta / np.pi * dut.mul))
            yield dut.enable.eq(1)
            yield Tick()
            while not (yield dut.valid):
                yield Tick()
                yield dut.enable.eq(0)
            # print(f'θ{theta:6.3f}, sin(θ)={ans:6.3f}, cordic={((yield dut.sine) / dut.mul):6.3f}')
            assert ((yield dut.sine) / dut.mul) == ans_y
            assert ((yield dut.cosine) / dut.mul) == ans_x

    sim.add_testbench(bench)
    with sim.write_vcd("cordic.vcd"):
        sim.run()
if args.verilog:
    if not args.output.parent.exists():
        args.output.parent.mkdir(parents=True)
    args.output.write_text(verilog.convert(dut, name='cordic', strip_internal_attrs=True))
