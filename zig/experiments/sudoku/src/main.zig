const std = @import("std");

pub fn main() anyerror!void {
    const arguments = std.os.argv;

    std.debug.print("There were {d} arguments.\n", .{arguments.len});

    var args = std.process.args();

    _ = args.skip(); // don't care about the first argument
    const arg = args.next() orelse "Hello!";
    std.debug.print("{s}\n", .{arg});
}
