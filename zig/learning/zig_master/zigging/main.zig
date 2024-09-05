const std = @import("std");
const print = std.debug.print;

const comma = @import("terminal_utils.zig").comma;
const space = @import("terminal_utils.zig").space;
const newline = @import("terminal_utils.zig").newline;

// ----------------------------------------------------------------------------
fn print_evens(max: u8) void {
    const start: u8 = 1;
    print("Even numbers from {} to {} are:\n", .{ start, max });
    for (start..max + 1) |n| {
        if (n % 2 == 0) {
            print("{}", .{n});
            if (n < max) {
                space();
            }
        }
    }
    newline();
}

// ----------------------------------------------------------------------------
fn print_odds(max: u8) void {
    const start: u8 = 1;
    print("Odd numbers from {} to {} are:\n", .{ start, max });
    for (start..max + 1) |n| {
        if (n % 2 != 0) {
            print("{}", .{n});
            if (n < max) {
                space();
            }
        }
    }
    newline();
}

// ----------------------------------------------------------------------------
fn print_spaced(max: u8) void {
    var position: u8 = 1;

    print("Numbers from {} to {} are:\n", .{ position, max });

    while (position <= max) : (position += 1) {
        print("{}", .{position});
        if (position < max) {
            comma();
        }
    }
    newline();
}

// ----------------------------------------------------------------------------
fn sumOf(left: u16, right: u16) u32 {
    return left + right;
}

// ======================================================================= MAIN
pub fn main() !void {
    const max: u8 = 10;

    print_evens(max);
    newline();
    print_odds(max);
    newline();
    print_spaced(max);
}

// ====================================================================== TESTS
const assert = std.debug.assert;

// ----------------------------------------------------------------------------
test "sum_of 8 and 8" {
    const left: u8 = 8;
    const right: u8 = 8;
    const sum = sumOf(left, right);
    assert(sum == 16);
}
