const _rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});
const _std = @import("std");
const _cons = @import("../constants.zig");

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
    var prng = _std.Random.DefaultPrng.init(undefined);
    const rand = prng.random();

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
                env.nodes[idx] = Node{
                    .position = .{
                        px - ((offset - 1) / 2.0),
                        py,
                        pz - ((offset - 1) / 2.0),
                    },
                    .set = rand.boolean(),
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
        _rl.DrawSphere(.{ .x = node.position[0], .y = node.position[1], .z = node.position[2] }, 0.05, color);
    }
}
