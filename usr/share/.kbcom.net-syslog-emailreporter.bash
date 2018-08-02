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
   LOCAL_STRING_EMAILBODY="$LOCAL_DATETIME: $LOCAL_STRING_RAWMSG"

   LOCAL_EMAIL_SENDCOMMAND=$(command_replace_emailbody "$LOCAL_STRING_EMAILBODY")
   $(/bin/bash -c "$LOCAL_EMAIL_SENDCOMMAND")
  fi
 done
}

syslog_write_log()
{
 local LOCAL_STRING_RAWMSG
 local LOCAL_DATETIME
 local LOCAL_FILE_LOG

 LOCAL_DATETIME=$(/bin/date +%Y%m%d%H%M%S%N)

 echo "$CONFIG_FILE_LOGSUFFIX.$LOCAL_DATETIME" 1>"$CONFIG_FILE_LOGSUFFIX.logfile"

 while read LOCAL_STRING_RAWMSG
 do
  if [ "$LOCAL_STRING_RAWMSG" != "" ]
  then
   LOCAL_DATETIME=$(/bin/date)
   LOCAL_FILE_LOG=$(/usr/bin/head -n 1 "$CONFIG_FILE_LOGSUFFIX.logfile")
   LOCAL_STRING_EMAILBODY="$LOCAL_DATETIME: $LOCAL_STRING_RAWMSG"

   echo "$LOCAL_DATETIME: $LOCAL_STRING_RAWMSG" 1>>"$LOCAL_FILE_LOG"

   LOCAL_EMAIL_SENDCOMMAND=$(command_replace_emailbody "$LOCAL_STRING_EMAILBODY")
   $(/bin/bash -c "$LOCAL_EMAIL_SENDCOMMAND")
  fi
 done
}

syslog_writelogsendmail()
{
 local LOCAL_STRING_RAWMSG
 local LOCAL_DATETIME
 local LOCAL_FILE_LOG

 LOCAL_DATETIME=$(/bin/date +%Y%m%d%H%M%S%N)

 echo "$CONFIG_FILE_LOGSUFFIX.$LOCAL_DATETIME" 1>"$CONFIG_FILE_LOGSUFFIX.logfile"

 while read LOCAL_STRING_RAWMSG
 do
  if [ "$LOCAL_STRING_RAWMSG" != "" ]
  then
   LOCAL_DATETIME=$(/bin/date)
   LOCAL_FILE_LOG=$(/usr/bin/head -n 1 "$CONFIG_FILE_LOGSUFFIX.logfile")

   echo "$LOCAL_DATETIME: $LOCAL_STRING_RAWMSG" 1>>"$LOCAL_FILE_LOG"
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
 LOCAL_FILE_LOG=$(/usr/bin/head -n 1 "$CONFIG_FILE_LOGSUFFIX.logfile")

 echo "$CONFIG_FILE_LOGSUFFIX.$LOCAL_DATETIME" 1>"$CONFIG_FILE_LOGSUFFIX.logfile"

 if [ -s "$LOCAL_FILE_LOG" ]
 then
  sleep 10
  /bin/cat "$LOCAL_FILE_LOG" 1>> "$CONFIG_FILE_LOGSUFFIX.log"
  /bin/rm "$LOCAL_FILE_LOG"
 fi

 if [ -s "$CONFIG_FILE_LOGSUFFIX.log" ]
 then
  LOCAL_STRING_EMAILBODY=$(/bin/cat "$CONFIG_FILE_LOGSUFFIX.log")

  LOCAL_EMAIL_SENDCOMMAND=$(command_replace_emailbody "$LOCAL_STRING_EMAILBODY")
  $(/bin/bash -c "$LOCAL_EMAIL_SENDCOMMAND")

  if [ $? -eq 0 ]
  then
   /bin/rm "$CONFIG_FILE_LOGSUFFIX.log"
  fi
 fi
}
