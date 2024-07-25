const std = @import("std");

const Direction = enum { north, south, east, west };
const Value = enum(u2) { zero, one, two }; // enum with integer tag type, starts at 0

const Value2 = enum(u32) { // with custom values
    hundred = 100,
    thousand = 1000,
    million = 1000000,
    next, // will be 1000001
    next_next, // will be 1000002
};

const Suit = enum { // can have methods
    clubs,
    spades,
    diamonds,
    hearts,
    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
};

const Mode = enum { // can even have var and const!
    var count: u32 = 0;
    on,
    off,
};

// ====================================================================== TESTS
const expect = @import("std").testing.expect;

test "enum ordinal value" {
    try expect(@intFromEnum(Value.zero) == 0);
    try expect(@intFromEnum(Value.one) == 1);
    try expect(@intFromEnum(Value.two) == 2);
}

test "set enum ordinal value" {
    try expect(@intFromEnum(Value2.hundred) == 100);
    try expect(@intFromEnum(Value2.thousand) == 1000);
    try expect(@intFromEnum(Value2.million) == 1000000);
    try expect(@intFromEnum(Value2.next) == 1000001);
    try expect(@intFromEnum(Value2.next_next) == 1000002);
}

test "enum method" {
    try expect(Suit.spades.isClubs() == Suit.isClubs(.spades));
}

test "hmm" {
    Mode.count += 1;
    try expect(Mode.count == 1);
}
