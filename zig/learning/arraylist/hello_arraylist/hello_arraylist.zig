const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    // create empty arraylist, zero length, zero capacity
    var list = std.ArrayList(u8).init(gpa.allocator());
    defer list.deinit();

    // lists can be added to with append
    for ("Oh, this is interesting!") |ch| {
        try list.append(ch);
    }

    printListu8(list);

    // clear the list
    list.clearAndFree();

    // use the list like a stack
    try list.append('\n');
    try list.append('a');
    try list.append('\n');
    try list.append('b');
    try list.append('\n');
    try list.append('c');
    try list.append('\n');
    try list.append('0');
    try list.append('1');
    printListu8(list);

    std.debug.print("Now popping some items off the list. \n[{c}] [{c}]\n", .{ list.pop(), list.pop() });

    printListu8(list);

    // clear the list
    list.clearAndFree();

    // now use the list like a writer/stringbuffer, if it's u8, of course
    const writer = list.writer();
    _ = try writer.print("All of this goes into the arraylist, even the number {}.", .{42});
    printListu8(list);

    list.clearAndFree();
    // writer = list.writer();
    _ = try writer.print("12345", .{});
    printListu8(list);

    // use the list like an iterator
    while (list.popOrNull()) |ch| {
        std.debug.print("{c}\n", .{ch});
    }

    std.debug.print("\n", .{});
    printListu8(list);

    const simpleCopy = try badWayToMakeACopy(gpa.allocator(), "This is any old slice!");
    defer gpa.allocator().free(simpleCopy);
    std.debug.print("We have \"{s}\" in the copy.\n", .{simpleCopy});
}

fn printListu8(list: std.ArrayList(u8)) void {
    std.debug.print("list: ", .{});
    for (list.items) |item| {
        std.debug.print("{c}", .{item});
    }
    if (list.items.len == 0) {
        std.debug.print("<empty>", .{});
    }
    std.debug.print("\n\n", .{});
}

// use an arraylist inside the function, return it as an owned slice, the owner needs to manage
// the disposal of the memory
fn badWayToMakeACopy(allocator: std.mem.Allocator, slice: []const u8) ![]u8 {
    var list = try std.ArrayList(u8).initCapacity(allocator, slice.len);
    defer list.deinit();

    for (slice) |ch| list.appendAssumeCapacity(ch);

    return try list.toOwnedSlice();
}
