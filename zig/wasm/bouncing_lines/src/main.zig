const zjb = @import("zjb");

var canvas: zjb.Handle = undefined;

// ----------------------------------------------------------------- initCanvas
fn initCanvas() void {
    canvas = zjb.global("document").call("getElementById", .{zjb.constString("canvas")}, zjb.Handle);
    canvas.set("width", 640);
    canvas.set("height", 480);
}
// ======================================================================= MAIN
export fn main() void {
    zjb.global("console").call("log", .{zjb.constString("Hello from Zig")}, void);

    {
        initCanvas();
        defer canvas.release();

        const context = canvas.call("getContext", .{zjb.constString("2d")}, zjb.Handle);
        defer context.release();

        context.set("fillStyle", zjb.constString("#F7A41D"));

        // Zig logo by Zig Software Foundation, github.com/ziglang/logo
        const shapes = [_][]const f64{
            &[_]f64{ 46, 22, 28, 44, 19, 30 },
            &[_]f64{ 46, 22, 33, 33, 28, 44, 22, 44, 22, 95, 31, 95, 20, 100, 12, 117, 0, 117, 0, 22 },
            &[_]f64{ 31, 95, 12, 117, 4, 106 },

            &[_]f64{ 56, 22, 62, 36, 37, 44 },
            &[_]f64{ 56, 22, 111, 22, 111, 44, 37, 44, 56, 32 },
            &[_]f64{ 116, 95, 97, 117, 90, 104 },
            &[_]f64{ 116, 95, 100, 104, 97, 117, 42, 117, 42, 95 },
            &[_]f64{ 150, 0, 52, 117, 3, 140, 101, 22 },

            &[_]f64{ 141, 22, 140, 40, 122, 45 },
            &[_]f64{ 153, 22, 153, 117, 106, 117, 120, 105, 125, 95, 131, 95, 131, 45, 122, 45, 132, 36, 141, 22 },
            &[_]f64{ 125, 95, 130, 110, 106, 117 },
        };

        const xOffset: f64 = 640.0 / 2 - 153 / 2;
        const yOffset: f64 = 480.0 / 2 - 141 / 2;

        for (shapes) |shape| {
            context.call("moveTo", .{ xOffset + shape[0], yOffset + shape[1] }, void);
            for (1..shape.len / 2) |i| {
                context.call("lineTo", .{ xOffset + shape[2 * i], yOffset + shape[2 * i + 1] }, void);
            }
            context.call("fill", .{}, void);
        }
    }
}
