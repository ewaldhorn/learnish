const std = @import("std");
const print = std.debug.print;

const comma = @import("terminal_utils.zig").comma;
const space = @import("terminal_utils.zig").space;
const newline = @import("terminal_utils.zig").newline;

var myArray: [10]u16 = undefined;

// ----------------------------------------------------------------------------
fn display_array() void {
    print("=========================\n", .{});

    for (0..myArray.len) |n| {
        print("| {d:10}:{d:10} |\n", .{ n, myArray[n] });
    }

    print("=========================\n", .{});
}

// ----------------------------------------------------------------------------
fn add_random_values() void {
    print("Randomising array.\n", .{});
    var rand_impl = std.rand.DefaultPrng.init(42);

    for (0..myArray.len) |idx| {
        myArray[idx] = @mod(rand_impl.random().int(u16), 30000);
    }
}

// ----------------------------------------------------------------------------
pub fn array_fun() void {
    print("Array length is: {}\n", .{myArray.len});
    display_array();
    add_random_values();
    display_array();
}
