#!/bin/bash

DEFCONFIG=qemu_aarch64_virt_defconfig

if [ "$#" -ge 1 ]; then
   DEFCONFIG=$1
fi

readonly BR_CONFIG=buildroot/configs/"$DEFCONFIG"

set -e
. "$HOME/.cargo/env"

echo "Add config $DEFCONFIG"
cp configs/"$DEFCONFIG" "$BR_CONFIG"

echo "Apply config $DEFCONFIG"
cd buildroot
make "$DEFCONFIG"

echo "Build"
export FORCE_UNSAFE_CONFIGURE=1
make
cd -

echo "Pack"
tar -cvzf images.tar.gz -C buildroot/output/  images

echo "Done"
