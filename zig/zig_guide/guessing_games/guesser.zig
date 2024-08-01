const std = @import("std");

// -------------------------------------------------------------- getRandomGoal
fn getRandomGoal() !u8 {
    var seed: u64 = undefined;
    try std.posix.getrandom(std.mem.asBytes(&seed));

    var prng = std.rand.DefaultPrng.init(seed);
    const rand = prng.random();

    return rand.intRangeAtMost(u8, 1, 100);
}

// ======================================================================= MAIN
pub fn main() !void {
    const goal = try getRandomGoal();

    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    while (true) {
        try stdout.writeAll("Guess (1..100): ");
        const bare_line = try stdin.readUntilDelimiterAlloc(
            std.heap.page_allocator,
            '\n',
            8192,
        );
        defer std.heap.page_allocator.free(bare_line);

        const line = std.mem.trim(u8, bare_line, "\r");
        const guess = std.fmt.parseInt(u8, line, 10) catch |err| switch (err) {
            error.Overflow => {
                try stdout.writeAll("Please enter a number between 1 and 100\n");
                continue;
            },
            error.InvalidCharacter => {
                try stdout.writeAll("Please enter a valid number\n");
                continue;
            },
        };

        if (guess < goal) try stdout.writeAll("Too Small!\n");
        if (guess > goal) try stdout.writeAll("Too Big!\n");
        if (guess == goal) {
            try stdout.writeAll("Correct!\n");
            break;
        }
    }
}

// ====================================================================== TESTS
const expect = std.testing.expect;

test "random numbers are not too big or small" {
    var isOk = true;

    var counter: i16 = 0;

    while (counter < 500) : (counter += 1) {
        const tmp = try getRandomGoal();

        if ((tmp < 1) or (tmp > 100)) {
            isOk = false;
        }
    }

    try expect(isOk);
}
