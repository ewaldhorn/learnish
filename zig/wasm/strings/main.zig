// zig_code.zig

const std = @import("std");

// Allocator for WebAssembly linear memory
var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = general_purpose_allocator.allocator();

// Function to pass a string from Zig to JavaScript
export fn getStringFromZig() [*]const u8 {
    const message = "Hello from Zig!";
    const ptr = gpa.dupeZ(u8, message) catch unreachable;
    return ptr;
}

// Function to free the memory allocated for the string
export fn freeZigString(ptr: [*]const u8) void {
    gpa.free(std.mem.span(ptr));
}

// Function to receive a string from JavaScript
export fn receiveStringFromJS(ptr: [*]const u8, len: usize) void {
    const slice = ptr[0..len];
    // Do something with the string, e.g., print it
    std.debug.print("Received from JS: {s}\n", .{slice});
}

// Function to allocate memory for a string to be filled by JavaScript
export fn allocateForJS(len: usize) [*]u8 {
    const ptr = gpa.alloc(u8, len) catch unreachable;
    return ptr.ptr;
}

// Function to free memory allocated for JavaScript
export fn freeJSString(ptr: [*]u8) void {
    gpa.free(std.mem.span(ptr));
}
