const std = @import("std");

pub fn main() !void {
    // Create a channel to communicate integers
    var channel = std.sync.Channel(i32);

    // Spawn two tasks, one to send and another to receive
    const task1 = std.Thread.spawn(.{
        .name = "sender",
        .work = try channel.sender().runSend, // Removed defer
    });

    const task2 = std.Thread.spawn(.{
        .name = "receiver",
        .work = try channel.receiver().runReceive, // Removed defer
    });

    // Wait for both tasks to finish
    try task1.join();
    try task2.join();

    // Close the channel after the tasks are finished
    channel.close();
}

fn runSend(channel: *std.sync.Channel(i32)) !void {
    var i: i32 = 0;
    while (i < 10) : (i += 1) {
        if (channel.is_closed()) break;
        if (channel.is_full()) continue;
        try channel.send(i);
        std.debug.print("Sent: {}\n", .{i});
    }
}

fn runReceive(channel: *std.sync.Channel(i32)) !void {
    while (true) {
        if (channel.is_closed()) break;
        if (channel.is_empty()) continue;
        const value = try channel.receive();
        std.debug.print("Received: {}\n", .{value});
    }
}
