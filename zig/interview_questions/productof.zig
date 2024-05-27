const std = @import("std");

// ------------------------------------------------------------------------------------------------
// calculate the product of the array for each element, without that element
// for example:
// [1, 2, 3, 4] yields [24, 12, 8, 6]
// 2 * 3 * 4 = 24
// 1 * 3 * 4 = 12
// 1 * 2 * 4 = 8
// 1 * 2 * 3 = 6
// needs an allocator because we return a new slice owned by the caller
fn productOfArrayExceptSelf(alloc: std.mem.Allocator, src: []const i32) ![]i32 {
    var list = try std.ArrayList(i32).initCapacity(alloc, src.len);
    defer list.deinit();

    for (0.., src) |pos, _| {
        var tmp: i32 = 1;

        for (0.., src) |i, e| {
            if (i != pos) {
                tmp = tmp * e;
            }
        }

        try list.append(tmp);
    }

    return try list.toOwnedSlice();
}

// ------------------------------------------------------------------------------------------------
// similar solution, but don't use nested loops
fn productOfArrayExceptSelfAlternative(alloc: std.mem.Allocator, src: []const i32) ![]i32 {
    var list = try std.ArrayList(i32).initCapacity(alloc, src.len);
    defer list.deinit();

    // init our arraylist with 1's
    // not sure if there's a better way to do this
    for (0..src.len) |_| {
        try list.append(1);
    }

    // store the prefix products directly in the final array
    for (1..src.len) |pos| {
        list.items[pos] = src[pos - 1] * list.items[pos - 1];
    }

    // prepare to do the actual math
    var tmpSuffixProduct: i32 = 1;
    var pos: usize = src.len;

    // need to do some -1 ops because usize can't overflow to -1
    // multiply the position with the previous position(s), yielding the final answer
    while (pos > 0) : (pos -= 1) {
        list.items[pos - 1] = list.items[pos - 1] * tmpSuffixProduct;
        tmpSuffixProduct = tmpSuffixProduct * src[pos - 1];
    }

    return try list.toOwnedSlice();
}

// ========================================================================================== TESTS
const expect = std.testing.expect;
const allocator = std.testing.allocator;

// ------------------------------------------------------------------------------------------------
test "basic array" {
    const my_array = [_]i32{ 1, 2, 3, 4 };

    const result = try productOfArrayExceptSelf(allocator, &my_array);
    defer allocator.free(result); // remember to free the owned slice eventually
    // std.debug.print("\narray:{any}\n", .{result});

    try expect(result.len == 4);
    try expect(result[0] == 24);
    try expect(result[1] == 12);
    try expect(result[2] == 8);
    try expect(result[3] == 6);
}

// ------------------------------------------------------------------------------------------------
test "basic array alternative" {
    const my_array = [_]i32{ 1, 2, 3, 4 };

    const result = try productOfArrayExceptSelfAlternative(allocator, &my_array);
    defer allocator.free(result); // remember to free the owned slice eventually

    // std.debug.print("\narray:{any}\n", .{result});

    try expect(result.len == 4);
    try expect(result[0] == 24);
    try expect(result[1] == 12);
    try expect(result[2] == 8);
    try expect(result[3] == 6);
}

// ------------------------------------------------------------------------------------------------
test "basic array, simplified testing" {
    const expected = [_]i32{ 24, 12, 8, 6 };

    const result = try productOfArrayExceptSelf(allocator, &[_]i32{ 1, 2, 3, 4 });
    defer allocator.free(result); // remember to free the owned slice eventually

    try expect(result.len == expected.len);

    for (0.., expected) |pos, _| {
        try expect(result[pos] == expected[pos]);
    }
}

// ------------------------------------------------------------------------------------------------
test "basic array, simplified testing alternative" {
    const expected = [_]i32{ 24, 12, 8, 6 };

    const result = try productOfArrayExceptSelfAlternative(allocator, &[_]i32{ 1, 2, 3, 4 });
    defer allocator.free(result); // remember to free the owned slice eventually

    try expect(result.len == expected.len);

    for (0.., expected) |pos, _| {
        try expect(result[pos] == expected[pos]);
    }
}

// ------------------------------------------------------------------------------------------------
test "inverse of basic array" {
    const my_array = [_]i32{ 4, 3, 2, 1 };
    const expected = [_]i32{ 6, 8, 12, 24 };

    const result = try productOfArrayExceptSelf(allocator, &my_array);
    defer allocator.free(result); // remember to free the owned slice eventually

    try expect(result.len == expected.len);

    for (0.., expected) |pos, _| {
        try expect(result[pos] == expected[pos]);
    }
}

// ------------------------------------------------------------------------------------------------
test "inverse of basic array alternative" {
    const my_array = [_]i32{ 4, 3, 2, 1 };
    const expected = [_]i32{ 6, 8, 12, 24 };

    const result = try productOfArrayExceptSelfAlternative(allocator, &my_array);
    defer allocator.free(result); // remember to free the owned slice eventually

    try expect(result.len == expected.len);

    for (0.., expected) |pos, _| {
        try expect(result[pos] == expected[pos]);
    }
}

// ------------------------------------------------------------------------------------------------
test "longer input" {
    const my_array = [_]i32{ 10, 3, 5, 6, 2 };
    const expected = [_]i32{ 180, 600, 360, 300, 900 };

    const result = try productOfArrayExceptSelf(allocator, &my_array);
    defer allocator.free(result); // remember to free the owned slice eventually

    try expect(result.len == expected.len);

    for (0.., expected) |pos, _| {
        try expect(result[pos] == expected[pos]);
    }
}

// ------------------------------------------------------------------------------------------------
test "longer input alternative" {
    const my_array = [_]i32{ 10, 3, 5, 6, 2 };
    const expected = [_]i32{ 180, 600, 360, 300, 900 };

    const result = try productOfArrayExceptSelfAlternative(allocator, &my_array);
    defer allocator.free(result); // remember to free the owned slice eventually

    try expect(result.len == expected.len);

    for (0.., expected) |pos, _| {
        try expect(result[pos] == expected[pos]);
    }
}
