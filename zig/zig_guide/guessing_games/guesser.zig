const std = @import("std");

// -------------------------------------------------------------- getRandomGoal
fn getRandomGoal() !u8 {
    var seed: u64 = undefined;
    try std.posix.getrandom(std.mem.asBytes(&seed));

    var prng = std.rand.DefaultPrng.init(seed);
    const rand = prng.random();

    return rand.intRangeAtMost(u8, 1, 100);
}

// -------------------------------------------------------------- validateGuess
fn validateGuess(guess: u8, goal: u8, out: std.fs.File.Writer) !bool {
    var mustQuit = false;

    if (guess < goal) try out.writeAll("Too Small!\n");
    if (guess > goal) try out.writeAll("Too Big!\n");

    if (guess == goal) {
        try out.writeAll("Correct!\n");
        mustQuit = true;
    }

    return mustQuit;
}

// --------------------------------------------------------------- getUserGuess
fn getUserGuess() ![]const u8 {
    const stdin = std.io.getStdIn().reader();
    var buf: [100]u8 = undefined;

    const userInput = try stdin.readUntilDelimiterOrEof(&buf, '\n');

    if (userInput) |ui| {
        const line = std.mem.trim(u8, ui, "\r"); // for Windows...
        return line;
    }

    return "error";
}

// ======================================================================= MAIN
pub fn main() !void {
    const goal = try getRandomGoal();

    const stdout = std.io.getStdOut().writer();

    var guesses: usize = 0;
    while (true) {
        try stdout.writeAll("Guess (1..100): ");
        guesses += 1;
        const userGuess = try getUserGuess();

        const guess = std.fmt.parseInt(u8, userGuess, 10) catch |err| switch (err) {
            error.Overflow => {
                try stdout.writeAll("Please enter a number between 1 and 100\n");
                continue;
            },
            error.InvalidCharacter => {
                try stdout.writeAll("Please enter a valid number\n");
                continue;
            },
        };
        if (try validateGuess(guess, goal, stdout) == true) {
            break;
        }
    }

    std.debug.print("You got it in {d} guess{s}!\n", .{ guesses, if (guesses > 1) "es" else "" });
}

// ====================================================================== TESTS
const expect = std.testing.expect;

// ----------------------------------------------------------------------------
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
