const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Zig RPN Calculator\nType mc to clear memory slots, exit to quit.\n", .{});

    var repl: [1024]u8 = undefined;
    var memslot = [_]f64{0} ** 256;
    var memslot_index: usize = 0;

    repl_loop: while (true) {
        const line = try stdin.readUntilDelimiterOrEof(&repl, '\n');
        const input = std.mem.trimRight(u8, line.?, "\r\n");
        if (std.mem.eql(u8, input, "")) {
            continue;
        } else if (std.mem.eql(u8, input, "exit")) {
            return;
        } else if (std.mem.eql(u8, input, "mc")) {
            memslot_index = 0;
            continue;
        }

        var it = std.mem.splitSequence(u8, input, " ");

        var stack = [_]f64{0} ** 256;
        var sp: usize = 0;
        while (it.next()) |tok| {
            if (tok.len == 0) {
                continue :repl_loop;
            }
            switch (tok[0]) {
                '*' => {
                    stack[sp - 2] = stack[sp - 2] * stack[sp - 1];
                    sp -= 1;
                },
                '/' => {
                    stack[sp - 2] = stack[sp - 2] / stack[sp - 1];
                    sp -= 1;
                },
                '+' => {
                    stack[sp - 2] = stack[sp - 2] + stack[sp - 1];
                    sp -= 1;
                },
                '-' => {
                    stack[sp - 2] = stack[sp - 2] - stack[sp - 1];
                    sp -= 1;
                },
                '^' => {
                    stack[sp - 2] = std.math.pow(f64, stack[sp - 2], stack[sp - 1]);
                    sp -= 1;
                },
                '%' => {
                    stack[sp - 2] = try std.math.mod(f64, stack[sp - 2], stack[sp - 1]);
                    sp -= 1;
                },
                '~' => {
                    stack[sp - 1] = -stack[sp - 1];
                },
                '#' => continue :repl_loop,
                'M' => {
                    const index = std.fmt.parseInt(usize, tok[1..], 10) catch |err| {
                        std.debug.print("Error: {}", .{err});
                        std.debug.print("Invalid memory memory slot index in {s}\n", .{tok});
                        continue :repl_loop;
                    };
                    stack[sp] = memslot[index % 256];
                    sp += 1;
                },
                '0'...'9', '.' => {
                    const num = std.fmt.parseFloat(f64, tok) catch |err| {
                        std.debug.print("Error: {}", .{err});
                        std.debug.print("Invalid character in floating point number {s}\n", .{tok});
                        continue :repl_loop;
                    };
                    stack[sp] = num;
                    sp += 1;
                },
                else => {
                    if (std.mem.eql(u8, tok, "sin")) {
                        stack[sp - 1] = std.math.sin(stack[sp - 1]);
                    } else if (std.mem.eql(u8, tok, "cos")) {
                        stack[sp - 1] = std.math.cos(stack[sp - 1]);
                    } else if (std.mem.eql(u8, tok, "tan")) {
                        stack[sp - 1] = std.math.tan(stack[sp - 1]);
                    } else if (std.mem.eql(u8, tok, "sqrt") or std.mem.eql(u8, tok, "√")) {
                        stack[sp - 1] = std.math.sqrt(stack[sp - 1]);
                    } else if (std.mem.eql(u8, tok, "pi") or std.mem.eql(u8, tok, "𝜋")) {
                        stack[sp] = std.math.pi;
                        sp += 1;
                    } else if (std.mem.eql(u8, tok, "e")) {
                        stack[sp] = std.math.e;
                        sp += 1;
                    } else if (std.mem.eql(u8, tok, "avg")) {
                        const count = sp;
                        var sum: f64 = 0;
                        for (stack) |val| {
                            sum += val;
                        }
                        sp -= count;
                        stack[sp] = sum / @as(f64, @floatFromInt(count));
                        sp += 1;
                    } else {
                        try stdout.print("Invalid operation {s}\n", .{tok});
                        continue :repl_loop;
                    }
                },
            }
        }
        memslot[memslot_index % 256] = stack[sp - 1];
        try stdout.print("M{d} = {d}\n", .{ memslot_index % 256, stack[sp - 1] });
        memslot_index += 1;
    }
}
