#!/usr/bin/env bash

chown vmail:vmail -R /mail

/usr/sbin/dovecot -c /etc/dovecot/dovecot.conf -F

#echo "Running '$@'"
#exec '$@'
