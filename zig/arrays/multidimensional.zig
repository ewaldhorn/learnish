const std = @import("std");

const matrix4x4 = [4][4]f32{
    [_]f32{ 1.0, 0.0, 0.0, 0.0 },
    [_]f32{ 0.0, 1.0, 0.0, 1.0 },
    [_]f32{ 0.0, 0.0, 1.0, 0.0 },
    [_]f32{ 0.0, 0.0, 0.0, 1.0 },
};

// ________________________________________________________________________________________________
// ========================================================================================== TESTS
const expect = std.testing.expect;

test "can access matrix values" {
    try expect(matrix4x4[1][1] == 1.0);
}

test "can access all elements" {
    std.debug.print("\n\n-------\n", .{});
    for (matrix4x4) |row| {
        for (row) |entry| {
            std.debug.print("{d} ", .{entry});
        }
        std.debug.print("\n", .{});
    }
    std.debug.print("-------\n", .{});
}