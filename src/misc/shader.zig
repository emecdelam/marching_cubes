const _rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});
const _std = @import("std");

pub fn init_shader() _rl.Shader {
    const shader = _rl.LoadShader("shader.vert.glsl", "shader.frag.glsl");

    const light_pos = _rl.Vector3{ .x = 2.0, .y = 5.0, .z = 2.0 };
    _rl.SetShaderValue(shader, _rl.GetShaderLocation(shader, "lightPos"), &light_pos, _rl.SHADER_UNIFORM_VEC3);

    return shader;
}
