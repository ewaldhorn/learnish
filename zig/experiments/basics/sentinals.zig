const expect = @import("std").testing.expect;

test "sentinel termination" {
    const terminated = [3:0]u8{ 3, 2, 1 };
    try expect(terminated.len == 3);
    try expect(@as(*const [4]u8, @ptrCast(&terminated))[3] == 0);
}

test "sentinel termination terminated by 'e'" {
    const terminated = [3:'e']u8{ 3, 2, 1 };
    try expect(terminated.len == 3);
    try expect(@as(*const [4]u8, @ptrCast(&terminated))[3] == 'e');
}

test "string literal" {
    try expect(@TypeOf("hello") == *const [5:0]u8);
}

test "C string" {
    const c_string: [*:0]const u8 = "hello";
    var array: [5]u8 = undefined;

    var i: usize = 0;
    while (c_string[i] != 0) : (i += 1) {
        array[i] = c_string[i];
    }
}

test "coercion" {
    const a: [*:0]u8 = undefined;
    const b: [*]u8 = a;
    _ = b;

    const c: [5:0]u8 = undefined;
    const d: [5]u8 = c;
    _ = d;

    const e: [:0]f32 = undefined;
    const f: []f32 = e;
    _ = f;
}

test "sentinel terminated slicing" {
    var x = [_:0]u8{255} ** 3;
    const y = x[0..3 :0];
    _ = y;
}