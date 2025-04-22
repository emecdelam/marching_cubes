const _rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});
const _gl = @cImport(@cInclude("rlgl.h"));
const _std = @import("std");

pub var msh: _rl.Mesh = undefined;
pub var alloc: *_std.mem.Allocator = undefined;

pub fn init_mesh(allocator: *_std.mem.Allocator) !void {
    alloc = allocator;
    msh = _rl.Mesh{};
    msh.triangleCount = 0;
    msh.vertexCount = 0;
    msh.vertices = undefined;
    msh.texcoords = undefined;
    msh.normals = undefined;
    _gl.rlDisableBackfaceCulling();
}
pub fn add_triangle(p1: [3]f32, p2: [3]f32, p3: [3]f32) !void {
    msh.triangleCount += 1;
    msh.vertexCount = msh.triangleCount * 3;
    const count: usize = @intCast(msh.triangleCount);

    const vert_start = 9 * (count - 1);
    const tex_start = 6 * (count - 1);
    const norm_start = 9 * (count - 1);

    msh.vertices = @ptrCast(try alloc.realloc(msh.vertices[0..vert_start], count * 9));
    msh.texcoords = @ptrCast(try alloc.realloc(msh.texcoords[0..tex_start], count * 6));
    msh.normals = @ptrCast(try alloc.realloc(msh.normals[0..norm_start], count * 9));

    msh.vertices[vert_start + 0] = p1[0];
    msh.vertices[vert_start + 1] = p1[1];
    msh.vertices[vert_start + 2] = p1[2];
    msh.vertices[vert_start + 3] = p2[0];
    msh.vertices[vert_start + 4] = p2[1];
    msh.vertices[vert_start + 5] = p2[2];
    msh.vertices[vert_start + 6] = p3[0];
    msh.vertices[vert_start + 7] = p3[1];
    msh.vertices[vert_start + 8] = p3[2];

    msh.texcoords[tex_start + 0] = 0.0;
    msh.texcoords[tex_start + 1] = 0.0;
    msh.texcoords[tex_start + 2] = 1.0;
    msh.texcoords[tex_start + 3] = 0.0;
    msh.texcoords[tex_start + 4] = 0.0;
    msh.texcoords[tex_start + 5] = 1.0;

    for (0..3) |i| {
        msh.normals[norm_start + (i * 3) + 0] = 0.0;
        msh.normals[norm_start + (i * 3) + 1] = 1.0;
        msh.normals[norm_start + (i * 3) + 2] = 0.0;
    }

    //_rl.UploadMesh(&msh, false);
}

pub fn print_vertices() void {
    const vertex_count: usize = @intCast(msh.vertexCount);
    const vertices_slice: [*]f32 = @ptrCast(msh.vertices);

    for (0..vertex_count) |i| {
        const x = vertices_slice[i * 3 + 0];
        const y = vertices_slice[i * 3 + 1];
        const z = vertices_slice[i * 3 + 2];
        _std.debug.print("Vertex {}: x = {}, y = {}, z = {}\n", .{ i, x, y, z });
    }
}

pub fn print_normals() void {
    const vertex_count: usize = @intCast(msh.vertexCount);
    const normals: [*]f32 = @ptrCast(msh.normals);

    for (0..vertex_count) |i| {
        const x = normals[i * 3 + 0];
        const y = normals[i * 3 + 1];
        const z = normals[i * 3 + 2];
        _std.debug.print("Normal {}: x = {}, y = {}, z = {}\n", .{ i, x, y, z });
    }
}

pub fn final_mesh() void {
    const upload = @as([*c]_rl.Mesh, @ptrCast(&msh));
    _rl.UploadMesh(upload, false);
}
