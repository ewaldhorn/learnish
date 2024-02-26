const std = @import("std");

// Checks that a string contains no duplicate characters.
// Characters 0..9, a..z, A..Z are expected, anything else will break the algorithm for this
// exercise.

// Works by looping through each character, comparing it to each subsequent character.
// If a duplicate is found, returns false.
// If nothing was found, it defaults to returning true.
// Returns bool
pub fn noDuplicates_ByLoops(input: []const u8) bool {
    // don't bother if we don't have at least two characters
    if (input.len < 2) {
        return true;
    }

    var pos: usize = 0;

    while (pos < input.len) : (pos += 1) {
        var checking = pos + 1;
        while (checking < input.len) : (checking += 1) {
            if (input[pos] == input[checking]) {
                return false;
            }
        }
    }

    return true;
}

// Works by sorting the characters and then checking there are no repeats.
// Returns error or bool
pub fn noDuplicates_BySorting(allocator: std.mem.Allocator, input: []const u8) !bool {
    // don't bother if we don't have at least two characters
    if (input.len < 2) {
        return true;
    }

    // create a buffer from the input that we can sort
    const buffer = try allocator.alloc(u8, input.len);
    defer allocator.free(buffer); // remember to free it!

    // now sort the characters 
    std.mem.copyForwards(u8, buffer, input);
    std.mem.sort(u8, buffer, {}, comptime std.sort.asc(u8));

    var pos: usize = 0;

    while (pos < buffer.len-1) : (pos += 1) {
        if (buffer[pos] == buffer[pos + 1]) {
            return false;
        }
    }

    return true;
}

// Works by creating a hashmap of the characters to ensure there are no repeats.
// Returns error or bool
pub fn noDuplicates_ByHashMap(allocator: std.mem.Allocator, input: []const u8) !bool {
    if (input.len < 2) {
        return true;
    }

    var map = std.AutoHashMap(u8, bool).init(allocator);
    defer map.deinit();

    for (input) |c| {
        const result = map.get(c);
        const found = result orelse false;

        if (found) {
            return false;
        } else {
            // not found, add it
            try map.put(c, true);
        }
    }

    return true;
}

// ________________________________________________________________________________________________
// ========================================================================================== TESTS
const expect = std.testing.expect;
const test_allocator = std.testing.allocator;

// ---------------------------------------------------------------------------------------- ByLoops
test "(ByLoops) no duplicates - empty string" {
    const result = noDuplicates_ByLoops("");
    try expect(result);
}

test "(ByLoops) no duplicates - proper string" {
    const result = noDuplicates_ByLoops("abcde");
    try expect(result);
}

test "(ByLoops) no duplicates - has a duplicate" {
    const result = noDuplicates_ByLoops("aa");
    try expect(!result);
}

test "(ByLoops) no duplicates - has a duplicate at the end" {
    const result = noDuplicates_ByLoops("abcdefghABCDEFGa");
    try expect(!result);
}

// -------------------------------------------------------------------------------------- BySorting
test "(BySorting) no duplicates - empty string" {
    const result = try noDuplicates_BySorting(test_allocator, "");
    try expect(result);
}

test "(BySorting) no duplicates - proper string" {
    const result = try noDuplicates_BySorting(test_allocator, "abcde");
    try expect(result);
}

test "(BySorting) no duplicates - has a duplicate" {
    const result = try noDuplicates_BySorting(test_allocator, "aa");
    try expect(!result);
}

test "(BySorting) no duplicates - has a duplicate at the end" {
    const result = try noDuplicates_BySorting(test_allocator, "abcdefghABCDEFGa");
    try expect(!result);
}

// -------------------------------------------------------------------------------------- ByHashMap
test "(ByHashMap) no duplicates - empty string" {
    const result = try noDuplicates_ByHashMap(test_allocator, "");
    try expect(result);
}

test "(ByHashMap) no duplicates - proper string" {
    const result = try noDuplicates_ByHashMap(test_allocator, "abcde");
    try expect(result);
}

test "(ByHashMap) no duplicates - has a duplicate" {
    const result = try noDuplicates_ByHashMap(test_allocator, "aa");
    try expect(!result);
}

test "(ByHashMap) no duplicates - has a duplicate at the end" {
    const result = try noDuplicates_ByHashMap(test_allocator, "abcdefghABCDEFGa");
    try expect(!result);
}