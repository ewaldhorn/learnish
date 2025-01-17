zig build-exe src/main.zig -target wasm32-freestanding -femit-bin=site/module.wasm -O ReleaseSmall -fno-entry --export=add
