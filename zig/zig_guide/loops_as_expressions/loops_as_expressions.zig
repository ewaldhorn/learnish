fn rangeHasNumber(begin: usize, end: usize, number: usize) bool {
    var i = begin;
    return while (i < end) : (i += 1) {
        if (i == number) {
            break true;
        }
    } else false;
}

// ====================================================================== TESTS
const expect = @import("std").testing.expect;

test "while loop expression - has number" {
    try expect(rangeHasNumber(0, 10, 3));
}

test "while loop expression - does not have number" {
    try expect(rangeHasNumber(0, 10, 11) == false);
}
