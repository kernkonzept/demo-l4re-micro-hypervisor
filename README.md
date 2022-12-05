# L4Re Micro Hypervisor demo for Cortex-R52 and Cortex-R82

This package provides recipes to build a demo of the L4Re Micro Hypervisor for
Cortex-R based systems. It consists of the required L4Re components and a
number of guests, namely FreeRTOS, Zephyr and Linux.

# Build instructions

The repository uses git submodules. It is recommended to clone the repository
with the `--recurse-submodules` option. Alternatively you can do a

    $ git submodule update --init

after the initial clone. To build the demos you need the
[BobBuildTool](https://bob-build-tool.readthedocs.io). The recommended way is
to install via pip:

    $ pip3 install --user BobBuildTool

Make sure that `~/.local/bin` is on your `$PATH`. The demos are built by
invoking bob:

    $ bob dev demo-cortex-r52 -j
    $ bob dev demo-cortex-r82 -j

If you encounter build issues, you can retry adding the `--sandbox` switch.
This will do the build in an isolated container environment at the expense of
some more disk space.

# Running the demos

The output of the demos will be in `dev/dist/demo-cortex-r52/1/workspace/`
resp. `dev/dist/demo-cortex-r82/1/workspace/`. In each directory there is a
`run.sh` script that starts the Armv8-R Fixed Virtual Platform with the built
L4Re image. The scripts assume that the FVP emulator is in `$PATH`. The FVP can
be downloaded for free from the [Arm Architecture Models
website](https://developer.arm.com/downloads/-/arm-ecosystem-models). Make sure
to download the *Armv8-R AEM FVP* model. Just extract the archive somewhere and
add the `models/Linux64_GCC-9.3` directory to your `$PATH`. Note that the
`run.sh` scripts should be executed in a graphical environment, so that the
simulation can spawn xterm terminals.

The demos have been tested with Armv8-R AEM FVP versions 11.18, 11.19 and
11.21. Versions before 11.18 are known to *not* work.

# License

Detailed licensing and copyright information can be found in
the [LICENSE](LICENSE.spdx) file.
