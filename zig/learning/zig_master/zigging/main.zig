const std = @import("std");
const print = std.debug.print;
// ----------------------------------------------------------------------------
fn newline() void {
    print("\n", .{});
}
// ----------------------------------------------------------------------------
fn print_evens(max: i8) void {
    const start: i8 = 2;
    print("Even numbers from {} to {} are:\n", .{ start, max });
}

// ----------------------------------------------------------------------------
fn print_odds(max: i8) void {
    const start: i8 = 2;
    print("Odd numbers from {} to {} are:\n", .{ start, max });
}

// ======================================================================= MAIN
pub fn main() !void {
    const max: i8 = 10;

    print_evens(max);
    newline();
    print_odds(max);
}
