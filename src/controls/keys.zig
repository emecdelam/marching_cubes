const _rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});
const _std = @import("std");
const _cam = @import("camera.zig");
const _cons = @import("../constants.zig");

pub fn handle_key() void {
    // -- Movements
    if (_rl.IsMouseButtonDown(_rl.MOUSE_BUTTON_LEFT)) {
        _cam.move_target(.{ .x = -_rl.GetMouseDelta().x * 0.05, .y = _rl.GetMouseDelta().y * 0.05, .z = 0.0 });
    }
}
