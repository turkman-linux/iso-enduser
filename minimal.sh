#!/bin/bash
# enable live
ymp repo --update --ignore-gpg
ymp it shadow audit --no-emerge
ymp it e2fsprogs dialog grub parted dosfstools nano --no-emerge
# insert live-config
wget https://gitlab.com/turkman/devel/sources/live-boot/-/raw/master/live-config.initd -O /etc/init.d/live-config
wget https://gitlab.com/turkman/devel/sources/live-boot/-/raw/master/live-config.sh -O /usr/libexec/live-config
rm -f /sbin/init
wget https://gitlab.com/turkman/devel/sources/installer/-/raw/master/main.sh -O /sbin/init
chmod 755 /etc/init.d/live-config
chmod 755 /usr/libexec/live-config
chmod 755 /sbin/init
# fstab add tmpfs
echo "tmpfs /tmp tmpfs rw 0 0" > /etc/fstab
ln -s /proc/mounts /etc/mtab
# enable login from shadow
sed -i "s|#agetty_options.*|agetty_options=\" -l /usr/bin/login\"|" /etc/conf.d/agetty
chmod u+s /bin/su /usr/bin/su
# set language
mkdir -p /lib64/locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "" >> /etc/locale.gen
locale-gen
sed -i "s/C/en_US/g" /etc/profile.d/locale.sh
# install cinnamon
ymp repo --update --allow-oem --ignore-gpg
ymp it xinit xorg-server xterm freetype xauth xkbcomp xkeyboard-config @x11.drivers --no-emerge --allow-oem
ymp it elogind shadow pipewire wireplumber libtool firefox-installer mousepad gpicview fuse fuse2 --no-emerge --allow-oem
ymp it @cinnamon caribou dejavu adwaita-icon-theme gsettings-desktop-schemas elementary-appcenter --no-emerge --allow-oem
# install wifi and bluetooth
ymp it wpa_supplicant networkmanager bluez --no-emerge --allow-oem
# update hicolor icons
gtk-update-icon-cache /usr/share/icons/hicolor/
# enable services
rc-update add elogind
rc-update add eudev
rc-update add fuse
rc-update add upowerd
rc-update add live-config
rc-update add hostname
rc-update add wpa_supplicant
rc-update add networkmanager
rc-update add bluetooth
ymp clean --allow-oem
exit 0
