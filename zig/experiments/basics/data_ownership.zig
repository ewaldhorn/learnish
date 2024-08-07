const std = @import("std");
const builtin = @import("builtin");

pub fn main() !void {
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	const allocator = gpa.allocator();

	var lookup = std.StringHashMap(User).init(allocator);
	
    // this line just isn't going to cut it - the name buffers won't get freed
    // defer lookup.deinit();

    // !! Nasty solution - free everything at the end
    defer {
	    var it = lookup.keyIterator();
	    while (it.next()) |key| {
		    allocator.free(key.*);
	    }
	    lookup.deinit();
    }

	// stdin is an std.io.Reader
	// the opposite of an std.io.Writer, which we already saw
	const stdin = std.io.getStdIn().reader();

	// stdout is an std.io.Writer
	const stdout = std.io.getStdOut().writer();

	var i: i32 = 0;
	while (true) : (i += 1) {
		var buf: [30]u8 = undefined;
		try stdout.print("Please enter a name: ", .{});
		if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
			var name = line;
			if (builtin.os.tag == .windows) {
				// In Windows lines are terminated by \r\n.
				// We need to strip out the \r
				name = std.mem.trimRight(u8, name, "\r");
			}
			if (name.len == 0) {
				break;
			}

            // this line is a problem - the name buffer does not live long enough
			// try lookup.put(name, .{.power = i});

            // !! Solution !!
            // replace the existing lookup.put with these two lines
            const owned_name = try allocator.dupe(u8, name);

            // name -> owned_name
            try lookup.put(owned_name, .{.power = i});
		}
	}

    // debug code starts
    var it = lookup.iterator();
    while (it.next()) |kv| {
	    std.debug.print("{s} == {any}\n", .{kv.key_ptr.*, kv.value_ptr.*});
    }
    // debug code ends

	const has_leto = lookup.contains("Leto");
	std.debug.print("{any}\n", .{has_leto});
}

const User = struct {
	power: i32,
};