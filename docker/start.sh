#!/bin/bash
cp -f /otrs.cnf /etc/mysql/conf.d/otrs.cnf
cp /opt/otrs/var/cron/otrs_daemon.dist /opt/otrs/var/cron/otrs_daemon
/opt/otrs/bin/Cron.sh start otrs
apache2ctl -D FOREGROUND

