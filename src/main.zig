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
const _msh = @import("mesh/mesh.zig");
const _stp = @import("controls/step.zig");
const _sha = @import("mesh/shader.zig");

pub fn main() anyerror!void {
    _std.log.info("Starting program", .{});
    // Allocator
    var arena = _std.heap.ArenaAllocator.init(_std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    // -- Window
    _rl.SetConfigFlags(_rl.FLAG_FULLSCREEN_MODE);
    _rl.InitWindow(_cons.WINDOW_WIDTH, _cons.WINDOW_HEIGHT, "Basic Raymarching");
    defer _rl.CloseWindow();

    _std.log.info("Window created", .{});

    // -- FPS target
    //_rl.SetTargetFPS(60);

    // -- Inits
    try _msh.init_mesh(&allocator); // fails to insufficient memory
    _cam.init_camera();
    const camera: *_rl.Camera = _cam.get_camera_ptr();
    var env = try _cube.init_nodes(allocator);
    defer env.deinit(allocator);
    const shader = _sha.init_shader();
    defer _rl.UnloadShader(shader);

    // -- Marching cubes
    _cube.march_cubes(env);
    _std.log.info("Triangle count : {}", .{_msh.msh.triangleCount});
    var mat = _rl.LoadMaterialDefault();
    mat.shader = shader;
    _msh.final_mesh();

    // -- Main loop
    var t: f32 = 0.0;
    _std.log.info("Entering main loop", .{});
    while (!_rl.WindowShouldClose()) {
        const cam: [*c]_rl.Camera = @ptrCast(camera);
        _rl.UpdateCamera(cam, _rl.CAMERA_FREE);
        const dt = _rl.GetFrameTime();
        if (dt < 0.016) {
            t += 0.016;
        } else {
            t += dt;
        }
        //camera.position = .{ .x = 7.0 * _std.math.sin(t / 4.0), .y = 7.0, .z = 7.0 * _std.math.cos(t / 4.0) };

        // -- Step
        _ = _stp.handle_step(t);

        // -- Key press
        //_key.handle_key();

        // -- Drawing
        _rl.BeginDrawing();
        defer _rl.EndDrawing();

        _rl.ClearBackground(.{ .r = 50, .g = 50, .b = 50, .a = 255 });

        // -- 3D mode
        _rl.BeginMode3D(camera.*); // no defer to keep the display in the scope

        _rl.BeginShaderMode(shader);
        _rl.DrawMesh(_msh.msh, mat, _rl.MatrixIdentity());
        _rl.EndShaderMode();

        //_cube.highlight_cube(env, _stp.step);

        _rl.EndMode3D();

        // -- Display
        try _gui.handle_display();
    }
}
