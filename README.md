# build-zig-cpp

An Example build.zig for a pure C++ project

Simply: `git clone <this_repo> && zig build`

Result is in `zig-out/bin`

## Details

1. All the magic happens in build.zig
2. I provide a win.cpp and main.cpp to showcase different OS capabilities built into zig
3. Most of this is not well documented yet, as of 0.13/0.14 zig era, places to get information:
    1. https://ziglang.org/learn/build-system/ (less than helpful for C++ specific users like us)
    2. https://ziglang.org/documentation/master/std/#std.Build (std.Build is the namespace where all the functions and types live - the meat of the discussion)

## build.zig Explanation

First, refer to [build.zig](./build.zig) in this repo.

Now, we first #include the zig standard library in this build.zig:

```zig
const std = @import("std");
```

Then we write what is main() for `zig build`:

```zig
pub fn build(b: *std.Build) void {
}
```

Then we set up default `.{}` target and optimization levels for my OS/build command. I.e. The system we're on.
You can modify what you are targeting with your `zig build` command and this is where that magic is respected.

```zig
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
```

`target` is documented [here](https://ziglang.org/documentation/master/std/#std.Build.standardTargetOptions), by clicking on [ResolvedTarget](https://ziglang.org/documentation/master/std/#std.Build.ResolvedTarget)
You can then follow the chain down to how I found the string `.windows` for this if statement:

```zig
if (target.result.os.tag == .windows) {
}
```

Below is Self-explanatory: We're declaring an executable with a name of "win", using the earlier target and optimization options. Nothing is added to this empty executable yet.

```zig
const exe = b.addExecutable(.{ 
    .name = "win",
    .target = target,
    .optimize = optimize
});
```

Now we add our single source file:

```zig
exe.addCSourceFile(.{ .file = b.path("win.cpp") });
```

Followed by actually linking against libc and libcpp, which is required to have `<iostream>` `<string>`, etc:

```zig
exe.linkLibC();
exe.linkLibCpp();
```

Note by default this is a dynamic link. To change to static link, set it up in the target options:

```zig
const target = b.standardTargetOptions(.{
    .libc_static = true, // Enable libc static linking
});
```

Finally, we tell it to install/create this executable:

```zig
b.installArtifact(exe);
```


