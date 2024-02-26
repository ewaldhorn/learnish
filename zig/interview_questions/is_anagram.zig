const std = @import("std");

pub fn isAnagram(allocator: std.mem.Allocator, left: []const u8, right: []const u8) !bool {
    if (left.len != right.len) {
        return false;
    }

    // create buffers so we can sort the characters
    const leftBuffer = try allocator.alloc(u8, left.len);
    defer allocator.free(leftBuffer);
    std.mem.copyForwards(u8, leftBuffer, left);
    std.mem.sort(u8, leftBuffer, {}, std.sort.asc(u8));

    const rightBuffer = try allocator.alloc(u8, right.len);
    defer allocator.free(rightBuffer);
    std.mem.copyForwards(u8, rightBuffer, right);
    std.mem.sort(u8, rightBuffer, {}, std.sort.asc(u8));

    var pos : usize = 0;

    // make sure the characters are the same once sorted
    while (pos < leftBuffer.len) : (pos += 1) {
        if (leftBuffer[pos] != rightBuffer[pos]) {
            return false;
        }
    }

    return true;
}

// ------------------------------------------------------------------------------------------------
pub fn isAnagramShorter(allocator: std.mem.Allocator, left: []const u8, right: []const u8) !bool {
    if (left.len != right.len) {
        return false;
    }

    // create buffers so we can sort the characters
    const leftBuffer = try allocator.alloc(u8, left.len);
    defer allocator.free(leftBuffer);
    std.mem.copyForwards(u8, leftBuffer, left);
    std.mem.sort(u8, leftBuffer, {}, std.sort.asc(u8));

    const rightBuffer = try allocator.alloc(u8, right.len);
    defer allocator.free(rightBuffer);
    std.mem.copyForwards(u8, rightBuffer, right);
    std.mem.sort(u8, rightBuffer, {}, std.sort.asc(u8));

    return std.mem.eql(u8, leftBuffer, rightBuffer);
}

// ------------------------------------------------------------------------------------------------
pub fn isAnagramShorterNoAllocation(left: []const u8, right: []const u8) !bool {
    if (left.len != right.len) {
        return false;
    }

    for (left) |ch| {
        if (countLetterOccurences(left, ch) != countLetterOccurences(right, ch)) {
            return false;
        }
    }

    return true;
}

// Count how many times a letter occurs in a word
fn countLetterOccurences(source: []const u8, target: u8) u8 {
    var count: u8 = 0;

    for (source) |letter| {
        if (std.ascii.toLower(letter) == std.ascii.toLower(target)) {
            count += 1;
        }
    }

    return count;
}

// ________________________________________________________________________________________________ 
// ========================================================================================== TESTS 
const expect = std.testing.expect;
const test_allocator = std.testing.allocator;

test "empty string" {
    try expect(try isAnagram(test_allocator, "", ""));
}

test "rat/tar" {
    try expect(try isAnagram(test_allocator, "rat", "tar"));
}

test "solo/solos" {
    try expect(!try isAnagram(test_allocator, "solo", "solos"));
}

test "solod/solos" {
    try expect(!try isAnagram(test_allocator, "solod", "solos"));
}

test "racecar/fastcar" {
    try expect(!try isAnagram(test_allocator, "racecar", "fastcar"));
}

// ---------------------------------------------------------------------------------------- Shorter
test "isAnagramShorter empty string" {
    try expect(try isAnagramShorter(test_allocator, "", ""));
}

test "isAnagramShorter rat/tar" {
    try expect(try isAnagramShorter(test_allocator, "rat", "tar"));
}

test "isAnagramShorter solo/solos" {
    try expect(!try isAnagramShorter(test_allocator, "solo", "solos"));
}

test "isAnagramShorter solod/solos" {
    try expect(!try isAnagramShorter(test_allocator, "solod", "solos"));
}

test "isAnagramShorter racecar/fastcar" {
    try expect(!try isAnagramShorter(test_allocator, "racecar", "fastcar"));
}

// ----------------------------------------------------------------------------------- NoAllocation
test "isAnagramShorterNoAllocation empty string" {
    try expect(try isAnagramShorterNoAllocation("", ""));
}

test "isAnagramShorterNoAllocation rat/tar" {
    try expect(try isAnagramShorterNoAllocation("rat", "tar"));
}

test "isAnagramShorterNoAllocation solo/solos" {
    try expect(!try isAnagramShorterNoAllocation("solo", "solos"));
}

test "isAnagramShorterNoAllocation solod/solos" {
    try expect(!try isAnagramShorterNoAllocation("solod", "solos"));
}

test "isAnagramShorterNoAllocation racecar/fastcar" {
    try expect(!try isAnagramShorterNoAllocation("racecar", "fastcar"));
}