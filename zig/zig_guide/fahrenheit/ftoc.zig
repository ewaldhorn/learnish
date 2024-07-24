const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer(); // get a handle to stdout

    const args = try std.process.argsAlloc(std.heap.page_allocator); // allocate args in memory
    defer std.process.argsFree(std.heap.page_allocator, args); // remember to free it before we exit

    if (args.len < 2) return error.ExpectedArgument; // error if we don't have sufficient args

    // perform conversion
    // first parse the float, do the conversion
    const f = try std.fmt.parseFloat(f32, args[1]);
    const c = (f - 32) * (5.0 / 9.0);

    // attempt to output the result
    try stdout.print("{d:.1}c\n", .{c});
}
