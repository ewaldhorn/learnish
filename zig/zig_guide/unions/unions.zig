const std = @import("std");

const Result = union {
    int: i64,
    float: f64,
    bool: bool,
};

// use an enum to see which field in an union is active
const Tag = enum { a, b, c };
const Tagged = union(Tag) { a: u8, b: f32, c: bool };

// infer the tag type
const TaggedInferred = union(enum) { a: u8, b: f32, c: bool };

// ====================================================================== TESTS
const expect = @import("std").testing.expect;

// will fail because .int is active, not .float
// test "simple union" {
//     var result = Result{ .int = 1234 };
//     result.float = 12.34;
// }

test "switch on tagged union" {
    var value = Tagged{ .b = 1.5 };
    switch (value) {
        .a => |*byte| byte.* += 1,
        .b => |*float| float.* *= 2,
        .c => |*b| b.* = !b.*,
    }
    try expect(value.b == 3);
}

// switch on inferred tag, set .c to !.c
test "switch on inferred tagged union" {
    var value = TaggedInferred{ .c = true };
    switch (value) {
        .a => |*byte| byte.* += 1,
        .b => |*float| float.* *= 2,
        .c => |*c| c.* = !c.*,
    }
    try expect(value.c == false);
}
