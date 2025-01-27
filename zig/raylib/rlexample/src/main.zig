const std = @import("std");
const rl = @import("raylib");

// ----------------------------------------------------------------------------
const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 600;
const WINDOW_TITLE = "Hello Raylib from Zig!";

// ----------------------------------------------------------------------------
pub fn main() !void {
    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, WINDOW_TITLE);
    defer rl.closeWindow();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.sky_blue);
    }
}
