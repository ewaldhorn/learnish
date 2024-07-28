pub const ComputationError = error{IllegalArgument};

// ---------------------------------------------------------------------- steps
pub fn steps(number: usize) anyerror!usize {
    var total: usize = 0;
    // numbers less than 1 are pointless to process
    if (number < 1) {
        return ComputationError.IllegalArgument;
    } else {
        var tmp = number;

        while (tmp > 1) {
            total += 1;

            if (tmp % 2 == 0) {
                tmp = tmp / 2;
            } else {
                tmp = (tmp * 3) + 1;
            }
        }
    }

    return total;
}

// ====================================================================== TESTS
const std = @import("std");
const testing = std.testing;

test "zero is an error" {
    const input = 0;
    const result = steps(input);
    try std.testing.expectError(ComputationError.IllegalArgument, result);
}

test "zero steps for one" {
    const expected: usize = 0;
    const actual = try steps(1);
    try testing.expectEqual(expected, actual);
}

test "divide if even" {
    const expected: usize = 4;
    const actual = try steps(16);
    try testing.expectEqual(expected, actual);
}

test "even and odd steps" {
    const expected: usize = 9;
    const actual = try steps(12);
    try testing.expectEqual(expected, actual);
}

test "large number of even and odd steps" {
    const expected: usize = 152;
    const actual = try steps(1_000_000);
    try testing.expectEqual(expected, actual);
}
