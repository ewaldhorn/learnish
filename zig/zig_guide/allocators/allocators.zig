const std = @import("std");
const expect = std.testing.expect;

// ====================================================================== TESTS
// The most basic allocator is std.heap.page_allocator. Whenever this allocator
// makes an allocation, it will ask your OS for entire pages of memory; an
// allocation of a single byte will likely reserve multiple kibibytes
test "allocation" {
    const allocator = std.heap.page_allocator;

    const memory = try allocator.alloc(u8, 100);
    defer allocator.free(memory);

    try expect(memory.len == 100);
    try expect(@TypeOf(memory) == []u8);
}

// The std.heap.FixedBufferAllocator is an allocator that allocates memory
// into a fixed buffer and does not make any heap allocations.
test "fixed buffer allocator" {
    var buffer: [1000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    const memory = try allocator.alloc(u8, 100);
    defer allocator.free(memory);

    try expect(memory.len == 100);
    try expect(@TypeOf(memory) == []u8);
}

// std.heap.ArenaAllocator takes in a child allocator and allows you to
// allocate many times and only free once. Here, .deinit() is called on the
// arena, which frees all memory. Using allocator.free in this example would
// be a no-op (i.e. does nothing).
test "arena allocator" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    _ = try allocator.alloc(u8, 1);
    _ = try allocator.alloc(u8, 10);
    _ = try allocator.alloc(u8, 100);
}

// alloc and free are used for slices. For single items, consider using
// create and destroy.
test "allocator create/destroy" {
    const byte = try std.heap.page_allocator.create(u8);
    defer std.heap.page_allocator.destroy(byte);
    byte.* = 128;
}

// The Zig standard library also has a general-purpose allocator. This is a
// safe allocator that can prevent double-free, use-after-free and can detect
// leaks. Safety checks and thread safety can be turned off via its
// configuration struct (left empty below). Zig's GPA is designed for safety
// over performance, but may still be many times faster than page_allocator.
test "GPA" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        //fail test; can't try in defer as defer is executed after we return
        if (deinit_status == .leak) expect(false) catch @panic("TEST FAIL");
    }

    const bytes = try allocator.alloc(u8, 100);
    defer allocator.free(bytes);
}
