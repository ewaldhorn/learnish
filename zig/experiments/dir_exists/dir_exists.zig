const std = @import("std");

pub fn main() !void {
    std.debug.print("Folder 'tmp' exists: {any}\n", .{dirExists("tmp")});
    // std.debug.print("Folder 'tmp' exists: {any}\n", .{dirExistsSimpler("tmp")});
}

pub fn dirExists(dpath: []const u8) !bool {
    var result = std.fs.cwd().openDir(dpath, .{});
    if (result) |*dir| {
        dir.close();
        return true;
    } else |err| {
        return switch (err) {
            error.FileNotFound => false,
            else => err,
        };
    }
}

pub fn dirExistsSimpler(dpath: []const u8) !bool {
    const dir = std.fs.cwd().openDir(dpath, .{}) catch |err| {
        return switch (err) {
            error.FileNotFound => false,
            else => err,
        };
    };
    dir.close();
    return true;
}
