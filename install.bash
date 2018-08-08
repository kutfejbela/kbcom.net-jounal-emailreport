# Ask: email from,to,subject,envelopefrom
# Ask: CA,krb5-ticket

/bin/ln -s /opt/kbcom.net-syslog-emailreporter/local/etc/rsyslog.d/90-kbcom.net-syslog-emailreporter.conf /etc/rsyslog.d/90-kbcom.net-syslog-emailreporter.conf
/bin/ln -s /opt/kbcom.net-syslog-emailreporter/local/etc/systemd/* /lib/systemd/system
/bin/systemctl enable --now syslog-emailreporter.timer
/bin/systemctl enable --now syslog-krb5.service
/bin/systemctl enable --now syslog-krb5.timer

/bin/mkdir /opt/kbcom.net-syslog-emailreporter/var
/bin/chown -R syslog:adm /opt/kbcom.net-syslog-emailreporter/var
/bin/systemctl restart rsyslog.service
