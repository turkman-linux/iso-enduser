#!/bin/bash
set -ex
mkdir /output -p
apt update || true
apt install git grub-pc-bin grub-efi grub-efi-ia32-bin squashfs-tools mtools xorriso rdfind -y || true
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
    echo "##### $(date) #####" > /output/turkman-$variant$suffix.revdep-rebuild
    mount -t proc proc rootfs/proc
    chroot rootfs ymp rbd --no-color 2>/dev/null | tee -a /output/turkman-$variant$suffix.revdep-rebuild
    umount -lf rootfs/proc
    cd ..
    rm -rf $variant$suffix
}
build cinnamon-enduser
