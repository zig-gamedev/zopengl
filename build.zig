const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseSafe,
    });

    const export_linkage = b.option(std.builtin.GlobalLinkage, "export-linkage", "Global linkage for exported OpenGL C symbols") orelse .strong;

    const build_options = b.addOptions();
    build_options.addOption(std.meta.Tag(std.builtin.GlobalLinkage), "linkage", @intFromEnum(export_linkage));

    const root = b.addModule("root", .{
        .root_source_file = b.path("src/zopengl.zig"),
    });
    root.addOptions("build_options", build_options);

    {
        const test_step = b.step("test", "Run zopengl tests");

        const tests = b.addTest(.{
            .name = "zopengl-tests",
            .root_module = b.createModule(.{
                .root_source_file = b.path("src/zopengl.zig"),
                .target = target,
                .optimize = optimize,
            }),
        });
        tests.root_module.addOptions("build_options", build_options);
        b.installArtifact(tests);

        test_step.dependOn(&b.addRunArtifact(tests).step);
    }

    const lib = b.addLibrary(.{
        .name = "zopengl",
        .linkage = .static,
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/zopengl.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    lib.root_module.addOptions("build_options", build_options);
    _ = b.installArtifact(lib);
}
