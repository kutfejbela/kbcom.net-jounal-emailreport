#!/bin/bash

CONFIG_FOLDER_MAIN="/opt/kbcom.net-syslog-emailreporter"

source "$CONFIG_FOLDER_MAIN/etc/kbcom.net-syslog-emailreporter.conf"

"$CONFIG_FOLDER_MAIN/usr/share/kbcom.net-syslog-emailreporter.bash" "$1"
