#!/bin/bash

GLOBAL_FOLDER_SCRIPT=$(/usr/bin/dirname "$0")
source "$GLOBAL_FOLDER_SCRIPT/.kbcom.net-syslog-emailreporter.bash"

SHELL_ACTION="$1"

case $SHELL_ACTION in
syslogsendemail)
 syslog_send_email
 ;;
syslogwritetolog)
 syslog_write_log
 ;;
syslogwritetologandsendmail)
 syslog_writelogsendemail
 ;;
flush)
 log_rotatemerge_sendemail
 ;;
*)
 ;;
esac
