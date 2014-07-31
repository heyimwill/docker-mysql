#MariaDB (https://mariadb.org/)

FROM phusion/baseimage:0.9.10
MAINTAINER William Dahlstrom <w.dahlstrom@me.com>

# Generate UTF-8 lang files just in case
RUN locale-gen en_US.UTF-8

# Update repositories, install prerequisites and add a new one
RUN apt-get -qq update
RUN apt-get -qqy install --no-install-recommends software-properties-common python-software-properties
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
RUN add-apt-repository 'deb http://ftp.ddg.lth.se/mariadb/repo/10.0/ubuntu trusty main'
RUN apt-get -qq update

# Install MariaDB
RUN apt-get -qqy install --force-yes mariadb-server

# Clean up apt when we're done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add our configuration files, scripts and set correct permissions
ADD conf/sysctl.conf /etc/sysctl.conf
ADD conf/my.cnf /etc/mysql/my.cnf
ADD scripts /scripts
RUN chmod +x /scripts/start.sh
RUN chmod 644 /etc/mysql/my.cnf
RUN touch /firstrun

# Expose port 3306
EXPOSE 3306

# Exposeour data and log direcotires
VOLUME ["/data", "/var/log/mysql"]

# Use baseimage-docker's init system
CMD ["/sbin/my_init", "--", "/scripts/start.sh"]
