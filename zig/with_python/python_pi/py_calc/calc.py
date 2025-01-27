from cffi import FFI

cffi = FFI()
cffi.cdef(
    """
      double calculate_pi(double x);
    """
)

import os

simple = cffi.dlopen(os.path.abspath("../zig/libcalc.dylib"))

print(simple.calculate(2))
