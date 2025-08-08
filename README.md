# About

[![Build Status](https://gitlab.com/alexs-sh/helix-buildroot/badges/master/pipeline.svg)](https://gitlab.com/alexs-sh/helix-buildroot/-/commits/master)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A helper project to integrate [helix](https://github.com/helix-editor/helix) into
[Buildroot](https://buildroot.org/).


# Status

Helix works on the test platforms: Raspberry Pi 3 (ARM32), QEMU (AArch64), and
Orange Pi (AArch64). However, some issues were observed during the build and
runtime on the target devices.

**Rendering issues and crashes over the serial port**. While Helix works fine over
SSH or a display connected to a device, running it over serial lines leads to
crashes and rendering problems.

The issue is caused by Crossterm, which can return 0 for the number of columns
and rows. This happens because `tcgetwinsize` can report success but fill
the values with zeros. `Ok((0,0))` usually is unexpected for apps and not handled.

Here are related issues & PRs:
- [Crossterm](https://github.com/crossterm-rs/crossterm/pull/1007)
- [Helix crash](https://github.com/helix-editor/helix/pull/14050)
- [Helix render](https://github.com/helix-editor/helix/issues/14101)

Seems [AiChat](https://github.com/sigoden/aichat/pull/1366) has the same problem by the same reasons.


**Building grammars**. Now Helix is built with grammars disabled. There are still two common problems to solve:

- The approaches conflict. Helix tries to pull and check grammars using `git`
during the build, while Buildroot expects all sources to be downloaded in
advance. No pulling or network operations should happen after that.

- Lack of configuration. While it's not critical to have an extra 100–200 MB
for hundreds of grammars on laptops with TBs of storage, this is not the case
for small devices. There, we usually need only 2-10 of the most common scripting
languages.

For now, it looks like both problems could be solved using `language.toml`.
But I haven't tested it much yet. Most likely, some other mismatches will be
discovered later.

# Examples

**QEMU aarch64**

![QEMU](./pics/qemu.png "QEMU")

**Raspberry PI3**

![Raspberry PI](./pics/rpi.png "Raspberry PI3")

# Build

The easiest way to build it is to use a script (like CI does).

```
git clone --recursive git@github.com:alexs-sh/helix-buildroot.git
cd helix-buildroot
./build-img.sh
```
Prepared images will be available at `buildroot/output/images` directory.

By default, the `build-img.sh` script builds a QEMU image. You can specify the
desired device by passing a configuration name to the script. For example,

```
./build-img.sh raspberrypi3_defconfig
```
Buildroot will generate images targeting the Raspberry Pi 3.

Please visit the `configs` directory to view the full list of supported platforms.

You can avoid using the script, as it only performs trivial operations such as
placing the modified configuration file in the correct location. Instead, you
can manually replace the configuration file and run Buildroot directly. For
example:

```
cp configs/qemu_aarch64_virt_defconfig buildroot/configs/qemu_aarch64_virt_defconfig
cd buildroot
make qemu_aarch64_virt_defconfig
make
```

If you need to add new packages or change the configuration, you can use the
default Buildroot tools located in the `buildroot` directory. For example:

```
cd buildroot
make menuconfig
```

Please note, Buildroot has its own requirements regarding the applications that
should be installed on the host system. For more details, refer to the [System requirements](https://buildroot.org/downloads/manual/manual.html#requirement)
section in the Buildroot documentation. Alternatively, you can check the
`dockerfiles` directory which contains instructions to prepare Debian-based
images used for CI builds.
