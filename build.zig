const std = @import("std");
const builtin = @import("builtin");
const uf2 = @import("uf2/src/main.zig");
const rp2040 = @import("rp2040/build.zig");
const microzig = @import("microzig/src/main.zig");

const Builder = std.build.Builder;
const Step = std.build.Step;
const LibExeObjStep = std.build.LibExeObjStep;

const Message = @import("src/device_info.zig").Message;

pub fn build(b: *Builder) !void {
    const mode = b.standardReleaseOptions();
    var examples = rp2040.Examples.init(b, mode);

    // inject uf2 file creation
    inline for (@typeInfo(rp2040.Examples).Struct.fields) |field| {
        const uf2_step = uf2.Uf2Step.create(@field(examples, field.name).inner, .{
            .family_id = .RP2040,
        });
        uf2_step.install();
    }

    examples.install();
}
