const _cons = @import("../constants.zig");

pub var step: u32 = 0;
pub fn handle_step(time: f32) u32 {
    if ((time - _cons.TIME_DELAY) / _cons.STEP_TIME < @as(f32, @floatFromInt(step))) {
        return step;
    }

    step += 1;
    return step;
}
