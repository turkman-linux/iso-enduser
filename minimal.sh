#!/bin/bash
# enable live
wget https://gitlab.com/turkman/devel/assets/misc/-/raw/main/live-config.initd -O /etc/init.d/live-config
chmod 755 /etc/init.d/live-config
rc-update add live-config
exit 0
