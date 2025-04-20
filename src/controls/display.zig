const _rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});
const _std = @import("std");
const _cam = @import("camera.zig");
const _cons = @import("../constants.zig");

pub fn handle_display() !void {
    // -- Fps count

    var buf: [16]u8 = undefined;
    const fps = try _std.fmt.bufPrintZ(&buf, "{d}", .{_rl.GetFPS()});
    _rl.DrawText(fps, 10, 10, 16, _rl.RAYWHITE);
}
