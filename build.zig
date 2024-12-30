const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    
    if (target.result.os.tag == .windows) {
        const exe = b.addExecutable(.{ 
            .name = "win",
            .target = target,
            .optimize = optimize
        });
        
        exe.addCSourceFile(.{ .file = b.path("win.cpp") });
        
        exe.linkLibC();
        exe.linkLibCpp();

        b.installArtifact(exe);
    } else {
        const exe = b.addExecutable(.{ 
            .name = "exe",
            .target = target,
            .optimize = optimize
        });
        
        exe.addCSourceFile(.{ .file = b.path("main.cpp") });
        
        exe.linkLibC();
        exe.linkLibCpp();

        b.installArtifact(exe);
    }
}