const std = @import("std");

const MySlice = struct { pointer: [*]const u8, length: usize };

// ---------------------------------------------------- displayItemsKnownLength
fn displayItemsKnownLength(items: [6]u8) void {
    std.debug.print("\nKnown length:\n", .{});

    for (1..items.len + 1) |idx| {
        std.debug.print("{d}: {d}\n", .{ idx, items[idx - 1] });
    }
}

// ------------------------------------------------------ displayItemsAnyLength
fn displayItemsAnyLength(items: [*]const u8, len: usize) void {
    std.debug.print("\nSpecified length:\n", .{});
    for (0..len) |idx| {
        std.debug.print("{d}: {d}\n", .{ idx + 1, items[idx] });
    }
}

// ----------------------------------------------- displayItemsUsingSliceStruct
fn displayItemsUsingSliceStruct(slice: MySlice) void {
    std.debug.print("\nSlice Struct:\n", .{});
    for (0..slice.length) |idx| {
        std.debug.print("{d}: {d}\n", .{ idx + 1, slice.pointer[idx] });
    }
}

// -------------------------------------------------- displayItemsUsingZigSlice
fn displayItemsUsingZigSlice(items: []const u8) void {
    std.debug.print("\nZig Slice:\n", .{});
    for (0..items.len) |idx| {
        std.debug.print("{d}: {d}\n", .{ idx + 1, items[idx] });
    }
}

// ======================================================================= MAIN
pub fn main() void {
    const scores = [_]u8{ 2, 4, 5, 2, 6, 5 };
    displayItemsKnownLength(scores);
    displayItemsAnyLength(&scores, scores.len);
    displayItemsUsingSliceStruct(MySlice{ .pointer = &scores, .length = scores.len });
    displayItemsUsingZigSlice(&scores);

    // get the first to elements of the array in a slice
    const sliced = scores[0..2];
    displayItemsUsingZigSlice(sliced);
}

// ====================================================================== TESTS
