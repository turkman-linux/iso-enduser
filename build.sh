#!/bin/bash
set -ex
mkdir /output -p
apt update || true
apt install git grub-pc-bin grub-efi grub-efi-ia32-bin squashfs-tools mtools xorriso -y || true
export FIRMWARE=1
function build(){
    variant=$1
    suffix=$2
    git clone https://gitlab.com/turkman/devel/assets/mkiso $variant$suffix
    cd $variant$suffix
    if [ -f ../$variant.sh ] ; then
        install ../$variant.sh custom
    fi
    sed -i "s/console=tty31//g" mkiso.sh
    bash -ex mkiso.sh
    mv turkman.iso /output/turkman-$variant$suffix.iso
    cd ..
    rm -rf $variant$suffix
}
build cinnamon-enduser
