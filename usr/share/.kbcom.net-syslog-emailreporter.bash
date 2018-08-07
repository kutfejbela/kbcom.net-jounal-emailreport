#!/bin/bash

command_replace_emailbody()
{
 local LOCAL_EMAIL_BODY="$1"

 echo "${CONFIG_EMAIL_SENDCOMMAND%%@EB@*}${LOCAL_EMAIL_BODY//\"/\\\"}${CONFIG_EMAIL_SENDCOMMAND#*@EB@}"
}

file_checkandcreate_log()
{
 local LOCAL_DATETIME
 local LOCAL_FILE_LOG

 if [ ! -f "$CONFIG_FILE_LOGSUFFIX.logfile" ]
 then
  LOCAL_DATETIME=$(/bin/date +%Y%m%d%H%M%S%N)

  echo "$CONFIG_FILE_LOGSUFFIX.$LOCAL_DATETIME" 1>"$CONFIG_FILE_LOGSUFFIX.logfile"
  echo -n "" 1> "$CONFIG_FILE_LOGSUFFIX.$LOCAL_DATETIME"
 else
  LOCAL_FILE_LOG=$(/usr/bin/head -n 1 "$CONFIG_FILE_LOGSUFFIX.logfile")

  if [ ! -f "$LOCAL_FILE_LOG" ]
  then
   echo -n "" 1> "$LOCAL_FILE_LOG"

   if [ ! -f "$LOCAL_FILE_LOG" ]
   then
    LOCAL_DATETIME=$(/bin/date +%Y%m%d%H%M%S%N)

    echo "$CONFIG_FILE_LOGSUFFIX.$LOCAL_DATETIME" 1>"$CONFIG_FILE_LOGSUFFIX.logfile"
    echo -n "" 1> "$CONFIG_FILE_LOGSUFFIX.$LOCAL_DATETIME"
   fi
  fi
 fi
}

syslog_send_email()
{
 local LOCAL_STRING_RAWMSG
 local LOCAL_DATETIME
 local LOCAL_STRING_MESSAGE
 local LOCAL_EMAIL_SENDCOMMAND

 while read LOCAL_STRING_RAWMSG
 do
  if [ "$LOCAL_STRING_RAWMSG" != "" ]
  then
   LOCAL_DATETIME=$(/bin/date)
   LOCAL_STRING_MESSAGE="$LOCAL_DATETIME: $LOCAL_STRING_RAWMSG"

   LOCAL_EMAIL_SENDCOMMAND=$(command_replace_emailbody "$LOCAL_STRING_MESSAGE")
   $(/bin/bash -c "$LOCAL_EMAIL_SENDCOMMAND")
  fi
 done
}

syslog_write_log()
{
 local LOCAL_STRING_RAWMSG
 local LOCAL_DATETIME
 local LOCAL_FILE_LOG
 local LOCAL_STRING_MESSAGE

 file_checkandcreate_log

 while read LOCAL_STRING_RAWMSG
 do
  if [ "$LOCAL_STRING_RAWMSG" != "" ]
  then
   LOCAL_DATETIME=$(/bin/date)
   LOCAL_FILE_LOG=$(/usr/bin/head -n 1 "$CONFIG_FILE_LOGSUFFIX.logfile")
   LOCAL_STRING_MESSAGE="$LOCAL_DATETIME: $LOCAL_STRING_RAWMSG"

   echo "$LOCAL_STRING_MESSAGE" 1>>"$LOCAL_FILE_LOG"
  fi
 done
}

syslog_writelogsendemail()
{
 local LOCAL_STRING_RAWMSG
 local LOCAL_DATETIME
 local LOCAL_FILE_LOG
 local LOCAL_STRING_MESSAGE
 local LOCAL_EMAIL_SENDCOMMAND

 file_checkandcreate_log

 while read LOCAL_STRING_RAWMSG
 do
  if [ "$LOCAL_STRING_RAWMSG" != "" ]
  then
   LOCAL_DATETIME=$(/bin/date)
   LOCAL_STRING_MESSAGE="$LOCAL_DATETIME: $LOCAL_STRING_RAWMSG"

   LOCAL_EMAIL_SENDCOMMAND=$(command_replace_emailbody "$LOCAL_STRING_MESSAGE")
   $(/bin/bash -c "$LOCAL_EMAIL_SENDCOMMAND")

   LOCAL_FILE_LOG=$(/usr/bin/head -n 1 "$CONFIG_FILE_LOGSUFFIX.logfile")
   echo "$LOCAL_STRING_MESSAGE" 1>>"$LOCAL_FILE_LOG"
  fi
 done
}

log_rotatemerge_sendemail()
{
 local LOCAL_DATETIME
 local LOCAL_FILE_LOG
 local LOCAL_STRING_MESSAGE
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
  LOCAL_STRING_MESSAGE=$(/bin/cat "$CONFIG_FILE_LOGSUFFIX.log")

  LOCAL_EMAIL_SENDCOMMAND=$(command_replace_emailbody "$LOCAL_STRING_MESSAGE")
  $(/bin/bash -c "$LOCAL_EMAIL_SENDCOMMAND")

  if [ $? -eq 0 ]
  then
   /bin/rm "$CONFIG_FILE_LOGSUFFIX.log"
  fi
 fi
}
