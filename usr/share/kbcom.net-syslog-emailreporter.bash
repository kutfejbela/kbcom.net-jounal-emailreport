#!/bin/bash

GLOBAL_FOLDER_SCRIPT=$(/usr/bin/dirname "$0")
source "$GLOBAL_FOLDER_SCRIPT/.kbcom.net-syslog-emailreport.bash"

CONFIG_EMAIL_SENDCOMMAND="proba@EB@PROBA"
command_replace_emailbody "E-mail \" üzenet"


case $SHELL_ACTION in
syslogsendemail)
 syslog_send_email
 ;;
syslogwritetolog)
 syslog_write_log
 ;;
flush)
 log_rotatemerge_sendemail
 ;;
*)
 ;;
esac
