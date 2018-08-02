#!/bin/bash

command_replace_emailbody()
{
 local LOCAL_EMAIL_BODY="$1"

 echo "${CONFIG_EMAIL_SENDCOMMAND%%@EB@*}${LOCAL_EMAIL_BODY/\"/\\\"}${CONFIG_EMAIL_SENDCOMMAND#*@EB@}"
}

syslog_send_email()
{
 local LOCAL_STRING_RAWMSG
 local LOCAL_DATETIME
 local LOCAL_STRING_EMAILBODY
 local LOCAL_EMAIL_SENDCOMMAND

 while read LOCAL_STRING_RAWMSG
 do
  if [ "$LOCAL_STRING_RAWMSG" != "" ]
  then
   LOCAL_DATETIME=$(/bin/date)
   LOCAL_STRING_EMAILBODY="$LOCAL_DATE: $LOCAL_STRING_RAWMSG"

   LOCAL_EMAIL_SENDCOMMAND=$(command_replace_emailbody "$LOCAL_STRING_EMAILBODY")
   $($LOCAL_EMAIL_SENDCOMMAND)
  fi
 done
}

syslog_write_log()
{
 local LOCAL_STRING_RAWMSG
 local LOCAL_DATETIME
 local LOCAL_FILE_LOG

 while read LOCAL_STRING_RAWMSG
 do
  if [ "$LOCAL_STRING_RAWMSG" != "" ]
  then
   LOCAL_DATETIME=$(/bin/date)
   LOCAL_FILE_LOG=$(/bin/head -n 1 "$CONFIG_FILE_LOGFILE")

   echo "$LOCAL_DATE: $LOCAL_STRING_RAWMSG" 1>"$CONFIG_FILE_LOGFILE"
  fi
 done
}

log_rotatemerge_sendemail()
{
 local LOCAL_DATETIME
 local LOCAL_FILE_LOG
 local LOCAL_STRING_EMAILBODY
 local LOCAL_EMAIL_SENDCOMMAND

 LOCAL_DATETIME=$(/bin/date +%Y%m%d%H%M%S%N)
 LOCAL_FILE_LOG=$(/bin/head -n 1 "$CONFIG_FILE_LOGFILE")

 echo "$SHELL_FILE_LOGFILE.$LOCAL_DATETIME" 1>"$SHELL_FILE_LOGFILE"

 sleep 10
 /bin/cat "$LOCAL_FILE_LOG" 1>> "$SHELL_FILE_LOGFILE.log"
 /bin/rm "$LOCAL_FILE_LOG"

 LOCAL_STRING_EMAILBODY=$(/bin/cat "$SHELL_FILE_LOGFILE.log")

 LOCAL_EMAIL_SENDCOMMAND=$(command_replace_emailbody "$LOCAL_STRING_EMAILBODY")
 $($LOCAL_EMAIL_SENDCOMMAND)

 if [ $? -eq 0 ]
 then
  /bin/rm "$SHELL_FILE_LOGFILE.log"
 fi
}
