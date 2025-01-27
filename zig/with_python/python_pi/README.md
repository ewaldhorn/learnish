# Python and Zig

Using Zig to extend Python.

There's a `build.sh` script in the `zig` directory to build the dynamic library
Python will load.

## Original idea
Based on <https://www.linkedin.com/pulse/supercharging-python-performance-zig-building-packages-bassem-aziz-glmlc/>,
though I took some liberties to adjust things just a tad.


### Zig build options
-build-lib: Tells Zig to build a library instead of an executable.
-fPIC: Generates position-independent code, which is required for shared libraries.
-dynamic: Generates a dynamically linked library.
-shared: Generates a shared library.
-O ReleaseSafe: Optimizes the code for release builds with safety features enabled.
-target wasm32-freestanding: Targets the WASM32 architecture and generates freestanding code (i.e., code that doesn't rely on a specific C library).
-l js: Links against the JavaScript library, which provides the std.js module.
your_zig_file.zig: The name of your Zig source file.
