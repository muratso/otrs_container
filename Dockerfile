FROM debian
RUN apt-get clean && apt-get update -y && apt-get upgrade -y
RUN apt-get install -y -f apache2 libapache2-mod-perl2
RUN apt-get install -y -f autoconf automake autotools-dev build-essential bzip2 curl git unzip subversion rsync vim wget cron
RUN apt-get install -y -f libapache2-mod-perl2 libdbd-mysql-perl libtimedate-perl libnet-dns-perl \
    libnet-ldap-perl libio-socket-ssl-perl libpdf-api2-perl libdbd-mysql-perl libsoap-lite-perl \
    libgd-text-perl libtext-csv-xs-perl libjson-xs-perl libgd-graph-perl libapache-dbi-perl
RUN wget http://ftp.otrs.org/pub/otrs/otrs-5.0.12.tar.gz && tar -xvf otrs-5.0.12.tar.gz -C /opt && mv /opt/otrs-5.0.12 /opt/otrs
RUN apt-get install -y -f libarchive-zip-perl libcrypt-eksblowfish-perl libdbd-odbc-perl libdbd-pg-perl libencode-hanextra-perl libmail-imapclient-perl libtemplate-perl libyaml-libyaml-perl

RUN perl /opt/otrs/bin/otrs.CheckModules.pl
RUN useradd -d /opt/otrs/ -c 'OTRS user' -G www-data otrs
RUN cd /opt/otrs/ && cp -v Kernel/Config.pm.dist Kernel/Config.pm && /opt/otrs/bin/Cron.sh start otrs

RUN cp -v /opt/otrs/scripts/apache2-httpd.include.conf /etc/apache2/sites-available/otrs.conf && a2ensite otrs && a2enmod perl && service apache2 restart

RUN cd /opt/otrs/ && bin/otrs.SetPermissions.pl --web-group=www-data
ADD ./docker/start.sh /start.sh
COPY ./docker/otrs.cnf /otrs.cnf
RUN chmod u+x /start.sh

EXPOSE 80
ENTRYPOINT ["/start.sh"]

