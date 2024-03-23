import numpy as np

for iterations in range(1, 32):
    tans = np.power(2, -np.arange(iterations, dtype=np.float64))
    phis = np.arctan(tans)
    k = np.prod(np.cos(phis))
    theta = np.linspace(- 1 / 2, 1 / 2, 10000)
    mul = 2**30
    tan_phis_fixed = (phis / np.pi * mul).astype(np.int64)
    theta_fixed = (theta * mul).astype(np.int64)

    x = np.ones_like(theta_fixed) * int(mul * k)
    y = np.zeros_like(theta_fixed)
    t = np.zeros_like(theta_fixed)

    for i in range(iterations):
        sign = (theta_fixed > t) * 2 - 1
        xn = x - (y >> i) * sign
        yn = y + (x >> i) * sign
        t = t + tan_phis_fixed[i] * sign
        x, y = xn, yn
        assert (-2**31 <= x).all() and (x < 2**31).all()
        assert (-2**31 <= y).all() and (y < 2**31).all()
    error = np.abs(x / mul - np.cos(theta * np.pi))
    print(
        f'iterations={iterations:02d} max error={error.max():.5e}, mean error={error.mean():.5e}'
    )
