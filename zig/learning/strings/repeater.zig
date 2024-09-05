const std = @import("std");
// ----------------------------------------------------------------------------
fn repeat(
    allocator: std.mem.Allocator,
    original: []const u8,
    times: usize,
) std.mem.Allocator.Error![]const u8 {
    var buffer = try allocator.alloc(
        u8,
        original.len * times,
    );

    for (0..times) |i| {
        std.mem.copyForwards(
            u8,
            buffer[(original.len * i)..],
            original,
        );
    }

    return buffer;
}

// ======================================================================= MAIN
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var arena = std.heap.ArenaAllocator.init(
        std.heap.page_allocator,
    );
    defer arena.deinit();

    const allocator = arena.allocator();

    const original = "Hello ";
    const repeated = try repeat(
        allocator,
        original,
        3,
    );

    // Prints "Hello Hello Hello "
    try stdout.print("{s}\n", .{repeated});
}

// ====================================================================== TESTS
const assert = std.debug.assert;
const test_allocator = std.testing.allocator;

// ----------------------------------------------------------------------------
test "repeater" {
    const original = "ABC";
    const reps: usize = 4;

    const result = try repeat(test_allocator, original, reps);
    defer test_allocator.free(result);

    assert(result.len == (original.len * reps));
}

// ----------------------------------------------------------------------------
test "repeated repeater" {
    const original = "This is a longer string of words.";
    const reps: usize = 12;

    const result = try repeat(test_allocator, original, reps);
    defer test_allocator.free(result);

    assert(result.len == (original.len * reps));
}
