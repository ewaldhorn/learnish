// from https://mtlynch.io/zig-extraneous-build/
// counts the chars piped in via standard in
// to run
// echo '00010203040506070809' | xxd -r -p | zig run main.zig
const std = @import("std");

pub fn countBytes(reader: anytype) !u32 {
    var count: u32 = 0;
    while (true) {
        _ = reader.readByte() catch |err| switch (err) {
            error.EndOfStream => {
                return count;
            },
            else => {
                return err;
            },
        };
        count += 1;
    }
}

pub fn main() !void {
    var reader = std.io.getStdIn().reader();

    var timer = try std.time.Timer.start();
    const start = timer.lap();
    const count = try countBytes(&reader);
    const end = timer.read();
    const elapsed_micros = @as(f64, @floatFromInt(end - start)) / std.time.ns_per_us;

    const output = std.io.getStdOut().writer();
    try output.print("bytes:           {}\n", .{count});
    try output.print("execution time:  {d:.3}µs\n", .{elapsed_micros});
}
