#!/bin/bash
cp -f /otrs.cnf /etc/mysql/conf.d/otrs.cnf
/opt/otrs/bin/Cron.sh start otrs
apache2ctl -D FOREGROUND

