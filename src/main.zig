const _rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});
const _std = @import("std");
const _cons = @import("constants.zig");
const _cam = @import("controls/camera.zig");
const _key = @import("controls/keys.zig");
const _gui = @import("controls/display.zig");
const _cube = @import("marching/cube.zig");

pub fn main() anyerror!void {
    _std.log.info("Starting program", .{});
    // Allocator
    var arena = _std.heap.ArenaAllocator.init(_std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // -- Window
    _rl.InitWindow(_cons.WINDOW_WIDTH, _cons.WINDOW_HEIGHT, "Basic Raymarching");
    defer _rl.CloseWindow();
    _std.log.info("Window created", .{});

    // -- FPS target
    _rl.SetTargetFPS(60);

    // -- Inits
    _cam.init_camera();
    const camera: *_rl.Camera = _cam.get_camera_ptr();
    var env = try _cube.init_nodes(allocator);
    defer env.deinit(allocator);

    // -- Main loop
    var t: f32 = 0.0;
    _std.log.info("Entering main loop", .{});
    while (!_rl.WindowShouldClose()) {
        t += _rl.GetFrameTime();
        camera.position = .{ .x = 7.0 * _std.math.sin(t / 4.0), .y = 7.0, .z = 7.0 * _std.math.cos(t / 4.0) };

        // -- Key press
        _key.handle_key();

        // -- Drawing
        _rl.BeginDrawing();
        defer _rl.EndDrawing();

        _rl.ClearBackground(.{ .r = 50, .g = 50, .b = 50, .a = 255 });

        // -- 3D mode
        _rl.BeginMode3D(camera.*); // no defer to keep the display in the scope

        _rl.DrawGrid(_cons.NUMBER_NODE * 2, _cons.NODE_SPACING);
        _cube.draw_nodes(env);
        _cube.draw_cubes(env);
        //_cube.highlight_cube(env, 0);

        _rl.EndMode3D();

        // -- Display
        try _gui.handle_display();
    }
}
