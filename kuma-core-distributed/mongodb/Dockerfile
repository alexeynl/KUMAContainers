FROM oraclelinux:9
COPY resources/kuma-dis[t]/kuma-ansible-installer-3.0.2.37.tar.gz kuma-dis[t]/kuma-ansible-installer-3.0.2.37.tar.gz /kuma-dist/
#common prerequisites
RUN dnf install hostname \
#Create KUMA service user
    && useradd --system kuma && usermod -s /usr/bin/false kuma \
#Task: Install MongoDB
#core/mongodb.yml
#Unarchive directory
    && dnf install compat-openssl11.x86_64 \
    && tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/mongodb.tar.gz" \
    && tar -zxvf kuma-ansible-installer/roles/kuma/files/mongodb.tar.gz \
    && mv mongodb /opt/ \
#Create additional directories
    && mkdir /opt/mongodb/cfg \
    && mkdir /opt/mongodb/data \
    && mkdir /opt/mongodb/log \
    && mkdir /opt/mongodb/logrotate \
#Generate configuration file
#COPY kuma-core-distributed/mongodb/config/mongod.conf /opt/mongodb/cfg/
#Generate systemd service
#COPY kuma-core-distributed/mongodb/config/kuma-mongodb.service /etc/systemd/system/
#Setup mongodb log rotation
    && dnf install logrotate
COPY kuma-core-distributed/mongodb/rootfs /
#COPY kuma-core-distributed/mongodb/config/mongo-logrotate.conf /opt/mongodb/logrotate/
RUN chmod 0644 /opt/mongodb/logrotate/mongo-logrotate.conf \
#COPY kuma-core-distributed/mongodb/config/cron-logrotate /etc/cron.daily/cron-logrotate
    && chmod 0755 /etc/cron.daily/cron-logrotate \

    && chmod 0644 /etc/systemd/system/*.service \
    && systemctl enable kuma-mongodb.service \
    && systemctl enable kuma-mongodb-init.service \
#COPY kuma-core-distributed/mongodb/config/kuma-mongodb-init.service /etc/systemd/system/kuma-mongodb-init.service

#COPY kuma-core-distributed/mongodb/scripts/prepare_mongodb.sh /usr/local/bin

    && chown -R kuma:kuma /opt/mongodb

CMD ["/sbin/init"]