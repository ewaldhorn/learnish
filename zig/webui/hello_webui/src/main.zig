const std = @import("std");
const webui = @import("webui");

pub fn main() !void {
    std.debug.print("Start of run.\n", .{});
    var nwin = webui.newWindow();

    nwin.setSize(800, 600);
    const didDisplay = nwin.showBrowser("<html><head><script src=\"/webui.js\"></script></head> Hello World ! </html>", .Chrome);

    if (didDisplay) {
        webui.wait();
    } else {}

    std.debug.print("End of run.\n", .{});
}
