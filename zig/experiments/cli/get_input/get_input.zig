// Gets user input from the CLI
const std = @import("std");

// ======================================================================= MAIN
pub fn main() !void {
    const stdin = std.io.getStdIn();
    const reader = stdin.reader();

    var buffer: [1024]u8 = undefined;

    std.debug.print("Who goes there? : ", .{});
    const result = try reader.readUntilDelimiterOrEof(&buffer, '\n');

    if (result) |input| {
        std.debug.print("Entered '{s}'.\n", .{input});
    } else {
        std.debug.print("Error reading value.\n", .{});
    }
}
