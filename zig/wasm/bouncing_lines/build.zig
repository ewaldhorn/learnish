const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{ .cpu_arch = .wasm32, .os_tag = .freestanding });
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseSmall });

    const dir = std.Build.InstallDir.bin;
    const zjb = b.dependency("zjb", .{});
    const bouncing_lines = b.addExecutable(.{
        .name = "bouncing_lines",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    bouncing_lines.root_module.addImport("zjb", zjb.module("zjb"));
    bouncing_lines.entry = .disabled;
    bouncing_lines.rdynamic = true;

    const extract_breakout = b.addRunArtifact(zjb.artifact("generate_js"));
    const extract_breakout_out = extract_breakout.addOutputFileArg("zjb_extract.js");
    extract_breakout.addArg("Zjb"); // Name of js class.
    extract_breakout.addArtifactArg(bouncing_lines);

    const bouncing_lines_build_step = b.step("bouncing_lines", "Build bouncing_lines");

    bouncing_lines_build_step.dependOn(&b.addInstallArtifact(bouncing_lines, .{
        .dest_dir = .{ .override = dir },
    }).step);
    bouncing_lines_build_step.dependOn(&b.addInstallFileWithDir(extract_breakout_out, dir, "zjb_extract.js").step);

    bouncing_lines_build_step.dependOn(&b.addInstallDirectory(.{
        .source_dir = b.path("static"),
        .install_dir = dir,
        .install_subdir = "",
    }).step);
}
