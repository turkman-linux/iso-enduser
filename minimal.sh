#!/bin/bash
# enable live
ymp repo --update --ignore-gpg
ymp it shadow audit --no-emerge
wget https://gitlab.com/turkman/devel/assets/misc/-/raw/main/live-config.initd -O /etc/init.d/live-config
chmod 755 /etc/init.d/live-config
echo "tmpfs /tmp tmpfs rw 0 0" > /etc/fstab
ln -s /proc/mounts /etc/mtab
sed -i "s|#agetty_options.*|agetty_options=\" -l /usr/bin/login\"|" /etc/conf.d/agetty
chmod u+s /bin/su /usr/bin/su
rc-update add live-config
rc-update add udhcpc
exit 0
