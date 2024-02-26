const std = @import("std");

// Checks that a string contains no duplicate characters.
// Characters 0..9, a..z, A..Z are expected, anything else will break the algorithm for this
// exercise.

// Works by looping through each character, comparing it to each subsequent character.
// If a duplicate is found, returns false.
// If nothing was found, it defaults to returning true.
pub fn noDuplicates_ByLoops(input: []const u8) bool {
    var pos : usize = 0;

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

// ________________________________________________________________________________________________ 
// ========================================================================================== TESTS 
const expect = std.testing.expect;

test "no duplicates - empty string" {
    const result = noDuplicates_ByLoops("");

    try expect(result);
}

test "no duplicates - proper string" {
    const result = noDuplicates_ByLoops("abcde");

    try expect(result);
}

test "no duplicates - has a duplicate" {
    const result = noDuplicates_ByLoops("aa");

    try expect(!result);
}

test "no duplicates - has a duplicate at the end" {
    const result = noDuplicates_ByLoops("abcdefghABCDEFGa");

    try expect(!result);
}