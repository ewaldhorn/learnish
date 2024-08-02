const zjb = @import("zjb");
const zig_logo_shapes = @import("zig_logo_shapes.zig").zig_logo_shapes;

var canvas: zjb.Handle = undefined;

// center of canvas, accounting for logo size
const xOffset: f64 = 640.0 / 2 - 153 / 2;
const yOffset: f64 = 480.0 / 2 - 141 / 2;

// ----------------------------------------------------------------- initCanvas
fn initCanvas() void {
    canvas = zjb.global("document").call("getElementById", .{zjb.constString("canvas")}, zjb.Handle);
    canvas.set("width", 640);
    canvas.set("height", 480);
}

// ------------------------------- renderZigLogo
fn renderZigLogo(context: zjb.Handle) void {
    context.set("fillStyle", zjb.constString("#F7A41D"));

    for (zig_logo_shapes) |shape| {
        context.call("moveTo", .{ xOffset + shape[0], yOffset + shape[1] }, void);
        for (1..shape.len / 2) |i| {
            context.call("lineTo", .{ xOffset + shape[2 * i], yOffset + shape[2 * i + 1] }, void);
        }
        context.call("fill", .{}, void);
    }
}

// ======================================================================= MAIN
export fn main() void {
    zjb.global("console").call("log", .{zjb.constString("Hello from Zig")}, void);

    {
        initCanvas();
        defer canvas.release();

        const context = canvas.call("getContext", .{zjb.constString("2d")}, zjb.Handle);
        defer context.release();

        renderZigLogo(context);
    }
}
