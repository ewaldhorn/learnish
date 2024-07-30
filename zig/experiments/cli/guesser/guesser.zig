const std = @import("std");

// ------------------------------------------------------------------- getGuess
fn getGuess() !u8 {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var buf: [10]u8 = undefined;

    try stdout.print("Guess a number between 1 and 100: ", .{});

    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |guess| {
        return std.fmt.parseInt(u8, guess, 10);
    } else {
        return error.InvalidParam;
    }
}

// ----------------------------------------------------------------------- main
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const rand = std.crypto.random;

    const value = rand.intRangeAtMost(i64, 1, 100);

    while (true) {
        const guess = try getGuess();
        if (guess == value) {
            break;
        }
        const message =
            if (guess < value)
            "low"
        else
            "high";
        try stdout.print("Too {s}\n", .{message});
    }

    try stdout.print("That's right\n", .{});
}
