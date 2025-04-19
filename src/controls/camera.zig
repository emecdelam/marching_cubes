const _rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});
const _std = @import("std");

pub var camera: _rl.Camera = undefined;

pub fn init_camera() void {
    camera = _rl.Camera{
        .position = .{ .x = 0.0, .y = 2.0, .z = 5.0 },
        .target = .{ .x = 0.0, .y = 1.0, .z = 0.0 },
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },
        .fovy = 60.0, // Field of view
        .projection = _rl.CAMERA_PERSPECTIVE,
    };
}

pub fn get_camera_ptr() *_rl.Camera {
    return &camera;
}

pub fn move_camera(displacement: _rl.Vector3) void {
    camera.position = _rl.Vector3Add(camera.position, displacement);
    move_target(displacement); // Sync target movement
}

pub fn move_target(target: _rl.Vector3) void {
    camera.target = _rl.Vector3Add(camera.target, target);
    _rl.UpdateCamera(&camera, camera.projection);
}
