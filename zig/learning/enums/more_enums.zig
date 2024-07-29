const std = @import("std");

const Selection = enum { rock, paper, scissors };
const Outcome = enum { lose, draw, win };

// ------------------------------------------------------- getOpponentSelection
fn getOpponentSelection(input: u8) Selection {
    return switch (input) {
        'A' => Selection.rock,
        'B' => Selection.paper,
        else => Selection.scissors,
    };
}

// --------------------------------------------------------- getPlayerSelection
fn getPlayerSelection(input: u8) Selection {
    return switch (input) {
        'X' => Selection.rock,
        'Y' => Selection.paper,
        else => Selection.scissors,
    };
}

// ----------------------------------------------------------------- getOutcome
fn getOutcome(playerSelection: Selection, opponentSelection: Selection) Outcome {
    return switch (playerSelection) {
        .rock => switch (opponentSelection) {
            .rock => Outcome.draw,
            .paper => Outcome.lose,
            .scissors => Outcome.win,
        },
        .paper => switch (opponentSelection) {
            .rock => Outcome.win,
            .paper => Outcome.draw,
            .scissors => Outcome.lose,
        },
        .scissors => switch (opponentSelection) {
            .rock => Outcome.lose,
            .paper => Outcome.win,
            .scissors => Outcome.draw,
        },
    };
}

// ------------------------------------------------------------ getOutcomeScore
fn getOutcomeScore(playerSelection: Selection, outcome: Outcome) usize {
    var score: usize = 0;

    score += switch (playerSelection) {
        .rock => 1,
        .paper => 2,
        .scissors => 3,
    };

    score += switch (outcome) {
        .draw => 3,
        .lose => 0,
        .win => 6,
    };

    return score;
}

// ----------------------------------------------------------------------- main
pub fn main() !void {
    // const fileName = "sample_puzzle_input.txt";
    const fileName = "puzzle_input_more_enums.txt";

    const file = try std.fs.cwd().openFile(fileName, .{});
    defer file.close();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const readBuffer = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(readBuffer);

    var total: usize = 0;
    var iterator = std.mem.tokenizeAny(u8, readBuffer, "\n");
    while (iterator.next()) |item| {
        const opponentSelection = getOpponentSelection(item[0]);
        const playerSelection = getPlayerSelection(item[2]);
        const outcome = getOutcome(playerSelection, opponentSelection);
        total += getOutcomeScore(playerSelection, outcome);
    }
    std.debug.print("Score: {}\n", .{total});
}
