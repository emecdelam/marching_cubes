const _rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});
const _gl = @cImport(@cInclude("rlgl.h"));
const _std = @import("std");

pub fn init_shader() _rl.Shader {
    const shader = _rl.LoadShader(0, "src/mesh/shader.fs");
    return shader;
}
