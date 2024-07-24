const expect = @import("std").testing.expect;

// ---------------------------------------------------------------------- total
fn total(values: []const u8) usize {
    var sum: usize = 0;

    for (values) |v| sum += v;

    return sum;
}

// ====================================================================== TESTS

// --------------------------------------------------------------------- slices
test "slices" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    const slice = array[0..3];

    try expect(total(slice) == 6);
}
// ------------------------------------------------------------------- slices 2
test "slices 2" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    const slice = array[0..3];

    try expect(@TypeOf(slice) == *const [3]u8);
}
