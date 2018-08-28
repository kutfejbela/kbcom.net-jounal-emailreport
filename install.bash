# Ask: email from,to,subject,envelopefrom
# Ask: CA,krb5-ticket

/bin/ln -s /opt/kbcom.net-jounal-emailreport/local/etc/rsyslog.d/90-kbcom.net-jounal-emailreport.conf /etc/rsyslog.d/90-kbcom.net-jounal-emailreport.conf
/bin/ln -s /opt/kbcom.net-jounal-emailreport/local/etc/systemd/* /lib/systemd/system
/bin/systemctl enable --now jounal-emailreport.timer
/bin/systemctl enable --now syslog-krb5.service
/bin/systemctl enable --now syslog-krb5.timer

/bin/mkdir /opt/kbcom.net-jounal-emailreport/var
/bin/chown -R syslog:adm /opt/kbcom.net-jounal-emailreport/var
/bin/systemctl restart rsyslog.service
