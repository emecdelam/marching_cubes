const _rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});
const _std = @import("std");
const _cons = @import("../constants.zig");
const _tab = @import("table.zig");
const _noi = @import("noise.zig");

pub const Node = struct { position: [3]f16, set: bool };

pub const Env = struct {
    nodes: []Node,
    count: usize,
    pub fn init(allocator: _std.mem.Allocator, node_count: usize) !*Env {
        var env = try allocator.create(Env);
        env.nodes = try allocator.alloc(Node, node_count);
        env.count = node_count;
        return env;
    }

    pub fn deinit(self: *Env, allocator: _std.mem.Allocator) void {
        allocator.free(self.nodes);
        allocator.destroy(self);
    }
};

pub fn init_nodes(allocator: _std.mem.Allocator) !*Env {
    const node_count = comptime _std.math.pow(usize, _cons.NUMBER_NODE, 3);
    var env = try Env.init(allocator, node_count);

    var idx: usize = 0;
    for (0.._cons.NUMBER_NODE) |z| {
        for (0.._cons.NUMBER_NODE) |y| {
            for (0.._cons.NUMBER_NODE) |x| {
                const px: f16 = @floatFromInt(x);
                const py: f16 = @floatFromInt(y);
                const pz: f16 = @floatFromInt(z);
                const offset: f16 = @floatFromInt(_cons.NUMBER_NODE);
                const noise = _noi.noise(f64, .{ .x = px - ((offset - 1) / 2.0), .y = py, .z = pz - ((offset - 1) / 2.0) });
                env.nodes[idx] = Node{
                    .position = .{
                        px - ((offset - 1) / 2.0),
                        py,
                        pz - ((offset - 1) / 2.0),
                    },
                    .set = noise > 0.15,
                };
                idx += 1;
            }
        }
    }
    return env;
}

pub fn draw_nodes(env: *Env) void {
    for (0..env.count) |i| {
        const node = env.nodes[i];
        var color: _rl.Color = undefined;
        if (node.set) {
            color = _rl.WHITE;
        } else {
            color = _rl.BLACK;
        }
        _rl.DrawSphere(.{ .x = node.position[0], .y = node.position[1], .z = node.position[2] }, 0.03, color);
    }
}
fn get_cube_node_indices(env: *Env, x: usize, y: usize, z: usize) [8]Node {
    const x_stride = 1;
    const y_stride = _cons.NUMBER_NODE;
    const z_stride = comptime _std.math.pow(usize, _cons.NUMBER_NODE, 2);
    const base = x + y * y_stride + z * z_stride;
    return .{
        env.nodes[base],
        env.nodes[base + x_stride],
        env.nodes[base + y_stride],
        env.nodes[base + y_stride + x_stride],
        env.nodes[base + z_stride],
        env.nodes[base + z_stride + x_stride],
        env.nodes[base + z_stride + y_stride],
        env.nodes[base + z_stride + y_stride + x_stride],
    };
}
fn get_nodes(env: *Env, index: usize) [8]Node {
    const number_cube_line: usize = comptime _cons.NUMBER_NODE - 1;
    const number_cube_square: usize = comptime _std.math.pow(usize, number_cube_line, 2);
    const cube_pos_z: usize = index / number_cube_square;
    const cube_pos_y: usize = (index / number_cube_line) % number_cube_line;
    const cube_pos_x: usize = index % number_cube_line;

    return get_cube_node_indices(env, cube_pos_x, cube_pos_y, cube_pos_z);
}
fn get_cube_mask(nodes: [8]Node) u8 {
    var mask: u8 = 0;
    for (nodes, 0..) |node, i| {
        if (node.set) {
            const s: u3 = @intCast(i);
            mask |= @as(u8, 1) << s;
        }
    }
    return mask;
}
fn to_vector(vec: [3]f16) _rl.Vector3 {
    return _rl.Vector3{ .x = vec[0], .y = vec[1], .z = vec[2] };
}
pub fn draw_cube(env: *Env, index: usize) void {
    const nodes: [8]Node = get_nodes(env, index);

    //_std.log.info("Nodes : {any}", .{nodes});
    const tri = _tab.triangle_table[get_cube_mask(nodes)];
    //_std.log.info("Mask : {b}", .{get_cube_mask(nodes)});
    //_std.log.info("Tri : {any}", .{tri});

    var i: usize = 0;
    while (tri[i] != -1) : (i += 3) {
        const e0: usize = @intCast(tri[i]);
        const e1: usize = @intCast(tri[i + 1]);
        const e2: usize = @intCast(tri[i + 2]);

        //_std.log.info("e0 {}", .{e0});
        //_std.log.info("e1 {}", .{e1});
        //_std.log.info("e2 {}", .{e2});

        const l0 = _tab.edge_to_vertices[e0];
        const l1 = _tab.edge_to_vertices[e1];
        const l2 = _tab.edge_to_vertices[e2];
        //_std.log.info("l0 {any}", .{l0});
        //_std.log.info("l1 {any}", .{l1});
        //_std.log.info("l2 {any}", .{l2});
        const m0 = .{
            (nodes[l0[0]].position[0] + nodes[l0[1]].position[0]) / 2.0,
            (nodes[l0[0]].position[1] + nodes[l0[1]].position[1]) / 2.0,
            (nodes[l0[0]].position[2] + nodes[l0[1]].position[2]) / 2.0,
        };
        const m1 = .{
            (nodes[l1[0]].position[0] + nodes[l1[1]].position[0]) / 2.0,
            (nodes[l1[0]].position[1] + nodes[l1[1]].position[1]) / 2.0,
            (nodes[l1[0]].position[2] + nodes[l1[1]].position[2]) / 2.0,
        };
        const m2 = .{
            (nodes[l2[0]].position[0] + nodes[l2[1]].position[0]) / 2.0,
            (nodes[l2[0]].position[1] + nodes[l2[1]].position[1]) / 2.0,
            (nodes[l2[0]].position[2] + nodes[l2[1]].position[2]) / 2.0,
        };
        //_std.log.info("Midpoint 0 {}", .{m0});
        //_std.log.info("Midpoint 1 {}", .{m1});
        //_std.log.info("Midpoint 2 {}", .{m2});
        _rl.DrawTriangle3D(to_vector(m0), to_vector(m1), to_vector(m2), _rl.GRAY);
        _rl.DrawTriangle3D(to_vector(m2), to_vector(m1), to_vector(m0), _rl.GRAY);
    }
}
pub fn highlight_cube(env: *Env, index: usize) void {
    if (index >= comptime _std.math.pow(usize, _cons.NUMBER_NODE - 1, 3)) {
        return;
    }
    const nodes: [8]Node = get_nodes(env, index);

    // These are the 12 edges of a cube, each as a pair of indices into the nodes array
    const edges = comptime [_][2]u8{
        .{ 0, 1 }, .{ 1, 3 }, .{ 3, 2 }, .{ 2, 0 }, // bottom face
        .{ 4, 5 }, .{ 5, 7 }, .{ 7, 6 }, .{ 6, 4 }, // top face
        .{ 0, 4 }, .{ 1, 5 }, .{ 2, 6 }, .{ 3, 7 }, // vertical edges
    };

    for (edges) |edge| {
        _rl.DrawLine3D(to_vector(nodes[edge[0]].position), to_vector(nodes[edge[1]].position), _rl.YELLOW);
    }
}

pub fn draw_cubes(env: *Env, num: usize) void {
    const num_cube = comptime _std.math.pow(usize, _cons.NUMBER_NODE - 1, 3);
    const top = @min(num_cube, num);
    for (0..top - 1) |i| {
        draw_cube(env, i);
    }
}
