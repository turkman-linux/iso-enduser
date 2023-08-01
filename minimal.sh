#!/bin/bash
# enable live
ymp repo --update --ignore-gpg
ymp it shadow audit --no-emerge
ymp it e2fsprogs dialog grub parted dosfstools --no-emerge
wget https://gitlab.com/turkman/devel/sources/live-boot/-/raw/master/live-config.initd -O /etc/init.d/live-config
wget https://gitlab.com/turkman/devel/sources/live-boot/-/raw/master/live-config.sh -O /usr/libexec/live-config
rm -f /sbin/init
wget https://gitlab.com/turkman/devel/sources/installer/-/raw/master/main.sh -O /sbin/init
chmod 755 /etc/init.d/live-config
chmod 755 /usr/libexec/live-config
chmod 755 /sbin/init
echo "tmpfs /tmp tmpfs rw 0 0" > /etc/fstab
ln -s /proc/mounts /etc/mtab
sed -i "s|#agetty_options.*|agetty_options=\" -l /usr/bin/login\"|" /etc/conf.d/agetty
chmod u+s /bin/su /usr/bin/su
rc-update add live-config
rc-update add udhcpc
rc-update add hostname
mkdir -p /lib64/locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "" >> /etc/locale.gen
locale-gen
sed -i "s/C/en_US/g" /etc/profile.d/locale.sh
exit 0
