const std = @import("std");
const js = std.js;

pub const document: js.Value = undefined;
pub const body: js.Value = undefined;
pub const console: js.Value = undefined;

pub fn init() void {
    document = js.global.Get("document");
    body = document.Get("body");
    console = js.global.Get("console");
}

pub fn addToBody(element: js.Value) void {
    addToElement(body, element);
}

pub fn log(message: []const u8) void {
    console.Call("log", .{message});
}

pub fn addToElement(parent: js.Value, child: js.Value) void {
    parent.Call("appendChild", .{child});
}

// ====================================================================== TESTS
test "log" {
    log("Hello, World!");
}

test "addToBody" {
    const element = document.Call("createElement", .{"div"});
    addToBody(element);
}
