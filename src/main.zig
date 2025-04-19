const _rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});
const _std = @import("std");
const _cons = @import("constants.zig");
const _cam = @import("controls/camera.zig");
const _key = @import("controls/keys.zig");

pub fn main() anyerror!void {
    _std.log.info("Starting program", .{});

    // Allocator
    var arena = _std.heap.ArenaAllocator.init(_std.heap.page_allocator);
    defer arena.deinit();

    _ = arena.allocator();

    // -- Window
    _rl.InitWindow(_cons.WINDOW_WIDTH, _cons.WINDOW_HEIGHT, "Basic Raymarching");
    defer _rl.CloseWindow();
    _std.log.info("Window created", .{});

    // -- FPS target
    _rl.SetTargetFPS(60);

    // -- Inits
    _cam.init_camera();
    const camera: *_rl.Camera = _cam.get_camera_ptr();

    // -- Main loop
    _std.log.info("Entering main loop", .{});
    while (!_rl.WindowShouldClose()) {
        // -- Key press
        _key.handle_key();

        // -- Drawing
        _rl.BeginDrawing();
        defer _rl.EndDrawing();

        _rl.ClearBackground(.{ .r = 50, .g = 50, .b = 50, .a = 255 });

        _rl.BeginMode3D(camera.*);
        defer _rl.EndMode3D();

        _rl.DrawCube(.{ .x = 0, .y = 0, .z = 0 }, 2.0, 2.0, 2.0, _rl.WHITE);
        _std.log.info("Position : {}", .{_cam.camera.position});
    }
}
