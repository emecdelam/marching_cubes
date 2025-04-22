const _rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});
const _gl = @cImport(@cInclude("rlgl.h"));
const _std = @import("std");

pub fn change_parameter(shader: _rl.Shader, param: []const u8, value: anytype, uniform: c_int) void {
    _rl.SetShaderValue(shader, _rl.GetShaderLocation(shader, param), value, uniform);
}

pub fn init_shader() _rl.Shader {
    const shader = _rl.LoadShader("src/mesh/shader.vs", "src/mesh/shader.fs");
    return shader;
}
