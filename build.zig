const std = @import("std");
const Build = @import("std").Build;

pub fn build(b: *Build) void {
    var target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // For some reason, "#include <new>"" in the binding glue only works with msvc.
    target.query.abi = .msvc;

    const im3d_c_cpp = b.addStaticLibrary(.{
        .name = "im3d_c_cpp",
        .target = target,
        .optimize = optimize,
    });
    im3d_c_cpp.linkLibC();
    im3d_c_cpp.addCSourceFiles(.{
        .files = &.{
            // Recast
            "im3d_glue.cpp",
            "im3d.cpp",
        },
        .flags = &.{},
    });

    b.installArtifact(im3d_c_cpp);

    var im3d = b.addModule("im3d", .{
        .root_source_file = .{ .path = "im3d.zig" },
        .target = target,
        .optimize = optimize,
    });

    im3d.linkLibrary(im3d_c_cpp);
}
