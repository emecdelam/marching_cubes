const std = @import("std");

fn hash3D(x: i32, y: i32, z: i32) u32 {
    const ux: u32 = @bitCast(x);
    const uy: u32 = @bitCast(y);
    const uz: u32 = @bitCast(z);
    var seed: u32 = ux ^ (uy *% 374761393) ^ (uz *% 668265263);
    seed ^= seed >> 13;
    seed *%= 1274126177;
    seed ^= seed >> 16;
    return seed;
}

fn lerp(a: f32, b: f32, t: f32) f32 {
    return a + t * (b - a);
}

pub fn linearValueNoise3D(x: f32, y: f32, z: f32) f32 {
    const xi: i32 = @intFromFloat(std.math.floor(x));
    const yi: i32 = @intFromFloat(std.math.floor(y));
    const zi: i32 = @intFromFloat(std.math.floor(z));

    const xf_xi: f32 = @floatFromInt(xi);
    const yf_yi: f32 = @floatFromInt(yi);
    const zf_zi: f32 = @floatFromInt(zi);

    const xf = x - xf_xi;
    const yf = y - yf_yi;
    const zf = z - zf_zi;

    const max_u32_f: f32 = @floatFromInt(std.math.maxInt(u32));

    const h000_f: f32 = @floatFromInt(hash3D(xi, yi, zi));
    const h100_f: f32 = @floatFromInt(hash3D(xi + 1, yi, zi));
    const h010_f: f32 = @floatFromInt(hash3D(xi, yi + 1, zi));
    const h110_f: f32 = @floatFromInt(hash3D(xi + 1, yi + 1, zi));
    const h001_f: f32 = @floatFromInt(hash3D(xi, yi, zi + 1));
    const h101_f: f32 = @floatFromInt(hash3D(xi + 1, yi, zi + 1));
    const h011_f: f32 = @floatFromInt(hash3D(xi, yi + 1, zi + 1));
    const h111_f: f32 = @floatFromInt(hash3D(xi + 1, yi + 1, zi + 1));

    const h000 = h000_f / max_u32_f;
    const h100 = h100_f / max_u32_f;
    const h010 = h010_f / max_u32_f;
    const h110 = h110_f / max_u32_f;
    const h001 = h001_f / max_u32_f;
    const h101 = h101_f / max_u32_f;
    const h011 = h011_f / max_u32_f;
    const h111 = h111_f / max_u32_f;

    const x00 = lerp(h000, h100, xf);
    const x10 = lerp(h010, h110, xf);
    const x01 = lerp(h001, h101, xf);
    const x11 = lerp(h011, h111, xf);

    const y0 = lerp(x00, x10, yf);
    const y1 = lerp(x01, x11, yf);

    return lerp(y0, y1, zf);
}

pub fn linearValueNoise3DAsBool(x: f32, y: f32, z: f32, threshold: f32) bool {
    return linearValueNoise3D(x, y, z) > threshold;
}
