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
        const forward = _rl.Vector3Normalize(_rl.Vector3Subtract(_cam.camera.target, _cam.camera.position));
        const side_x = _rl.Vector3Normalize(_rl.Vector3CrossProduct(forward, .{ .x = 0, .y = 1, .z = 0 }));
        const side_y = _rl.Vector3Normalize(_rl.Vector3CrossProduct(forward, .{ .x = -1, .y = 0, .z = 0 }));
        var direction = _rl.Vector3Add(forward, _rl.Vector3Scale(side_x, _rl.GetMouseDelta().x));
        direction = _rl.Vector3Add(direction, _rl.Vector3Scale(side_y, _rl.GetMouseDelta().y));
        _cam.move_target(direction);
    }
    if (_rl.IsKeyDown(_rl.KEY_RIGHT)) {
        const forward = _rl.Vector3Normalize(_rl.Vector3Subtract(_cam.camera.target, _cam.camera.position));
        const side = _rl.Vector3Normalize(_rl.Vector3CrossProduct(forward, .{ .x = 0, .y = 1, .z = 0 }));
        _cam.move_camera(_rl.Vector3Scale(_rl.Vector3Normalize(side), _cons.MOVEMENT_SPEED));
    }
    if (_rl.IsKeyDown(_rl.KEY_LEFT)) {
        const forward = _rl.Vector3Normalize(_rl.Vector3Subtract(_cam.camera.target, _cam.camera.position));
        const side = _rl.Vector3Normalize(_rl.Vector3CrossProduct(forward, .{ .x = 0, .y = -1, .z = 0 }));
        _cam.move_camera(_rl.Vector3Scale(_rl.Vector3Normalize(side), _cons.MOVEMENT_SPEED));
    }
    if (_rl.IsKeyDown(_rl.KEY_UP)) {
        const forward = _rl.Vector3Normalize(_rl.Vector3Subtract(_cam.camera.target, _cam.camera.position));
        _cam.move_camera(_rl.Vector3Scale(_rl.Vector3Normalize(forward), _cons.MOVEMENT_SPEED));
    }
    if (_rl.IsKeyDown(_rl.KEY_DOWN)) {
        const forward = _rl.Vector3Normalize(_rl.Vector3Subtract(_cam.camera.target, _cam.camera.position));
        _cam.move_camera(_rl.Vector3Scale(_rl.Vector3Normalize(forward), -_cons.MOVEMENT_SPEED));
    }
    if (_rl.IsKeyDown(_rl.KEY_PAGE_UP)) {
        _cam.move_camera(.{ .x = 0, .y = _cons.MOVEMENT_SPEED, .z = 0 });
    }
    if (_rl.IsKeyDown(_rl.KEY_PAGE_DOWN)) {
        _cam.move_camera(.{ .x = 0, .y = -_cons.MOVEMENT_SPEED, .z = 0 });
    }
}
