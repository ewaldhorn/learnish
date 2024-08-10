const std = @import("std");
const zjb = @import("zjb");
const alloc = std.heap.wasm_allocator;

const zig_logo_shapes = @import("zig_logo_shapes.zig").zig_logo_shapes;

var canvas: zjb.Handle = undefined;

const canvasWidth: f64 = 640.0;
const canvasHeight: f64 = 480.0;

// center of canvas, accounting for logo size
const xOffset: f64 = canvasWidth / 2 - 153 / 2;
const yOffset: f64 = canvasHeight / 2 - 141 / 2;

// variables for movement
var xMovement: f64 = 0.0;
var xOffsetChange: f64 = 1.0;

// ----------------------------------------------------------------- initCanvas
fn initCanvas() void {
    canvas = zjb.global("document").call("getElementById", .{zjb.constString("canvas")}, zjb.Handle);
    canvas.set("width", canvasWidth);
    canvas.set("height", canvasHeight);
}

// -------------------------------------------------------------- renderZigLogo
fn renderZigLogo(context: zjb.Handle) void {
    context.set("fillStyle", zjb.constString("#F7A41D"));

    for (zig_logo_shapes) |shape| {
        context.call("moveTo", .{ xMovement + xOffset + shape[0], yOffset + shape[1] }, void);
        for (1..shape.len / 2) |i| {
            context.call("lineTo", .{ xMovement + xOffset + shape[2 * i], yOffset + shape[2 * i + 1] }, void);
        }
        context.call("fill", .{}, void);
    }
}

// ------------------------------------------------------ updateOffsetPositions
fn updateOffsetPositions() void {
    xMovement += xOffsetChange;

    if (xMovement > 50.0 or xMovement < -50) {
        xOffsetChange *= -1;
    }

    {
        const formatted = std.fmt.allocPrint(alloc, "Runtime string: current xOffsetChange {d}", .{xMovement}) catch |e| zjb.throwError(e);
        defer alloc.free(formatted);

        const str = zjb.string(formatted);
        defer str.release();

        zjb.global("console").call("log", .{str}, void);
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
        updateOffsetPositions();
    }
}
