// JavaScript code

let wasmMemory;
let wasmInstance;

// Load the WebAssembly module
WebAssembly.instantiateStreaming(fetch('zig_code.wasm'), {
    env: {
        // Add any necessary environment functions here
    }
}).then(result => {
    wasmInstance = result.instance;
    wasmMemory = wasmInstance.exports.memory;

    // Example: Get string from Zig
    const zigStringPtr = wasmInstance.exports.getStringFromZig();
    const zigString = readStringFromMemory(zigStringPtr);
    console.log("String from Zig:", zigString);
    wasmInstance.exports.freeZigString(zigStringPtr);

    // Example: Send string to Zig
    const jsString = "Hello from JavaScript!";
    sendStringToZig(jsString);
});

// Function to read a string from WebAssembly memory
function readStringFromMemory(ptr) {
    const memory = new Uint8Array(wasmMemory.buffer);
    let str = '';
    let i = ptr;
    while (memory[i] !== 0) {
        str += String.fromCharCode(memory[i]);
        i++;
    }
    return str;
}

// Function to send a string to Zig
function sendStringToZig(str) {
    const bytes = new TextEncoder().encode(str);
    const ptr = wasmInstance.exports.allocateForJS(bytes.length);
    const memory = new Uint8Array(wasmMemory.buffer);
    memory.set(bytes, ptr);
    wasmInstance.exports.receiveStringFromJS(ptr, bytes.length);
    wasmInstance.exports.freeJSString(ptr);
}
