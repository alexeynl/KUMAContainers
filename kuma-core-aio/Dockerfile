FROM oraclelinux:9
COPY resources/kuma-dis[t]/kuma-ansible-installer-3.0.2.37.tar.gz kuma-dis[t]/kuma-ansible-installer-3.0.2.37.tar.gz /kuma-dist/
#common prerequisites
RUN dnf install hostname \
#Create KUMA service user
    && useradd --system kuma && usermod -s /usr/bin/false kuma \
#Create vendor directory
#Create KUMA directory
    && mkdir -p /opt/kaspersky/kuma/core/bin/ \

#Task: Install Kuma Updater
#core/kuma-updater.yml
#Unarchive directory
    && tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/kuma-updater.tar.gz" \
    && tar -zxvf /kuma-ansible-installer/roles/kuma/files/kuma-updater.tar.gz \
    && mv kuma-updater /opt/kaspersky/kuma/ \

#Task: Install MongoDB
#core/mongodb.yml
#Unarchive directory
    && dnf install compat-openssl11.x86_64 \
    && tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/mongodb.tar.gz" \
    && tar -zxvf kuma-ansible-installer/roles/kuma/files/mongodb.tar.gz \
    && mv mongodb /opt/kaspersky/kuma/ \
#Create additional directories
    && mkdir /opt/kaspersky/kuma/mongodb/cfg \
    && mkdir /opt/kaspersky/kuma/mongodb/data \
    && mkdir /opt/kaspersky/kuma/mongodb/log \
    && mkdir /opt/kaspersky/kuma/mongodb/logrotate \
#Generate configuration file
#COPY kuma-core-aio/config/mongodb/mongod.conf /opt/kaspersky/kuma/mongodb/cfg/
#Generate systemd service
#COPY kuma-core-aio/config/mongodb/kuma-mongodb.service /etc/systemd/system/
#Setup mongodb log rotation
    && dnf install logrotate \
#COPY kuma-core-aio/config/mongodb/mongo-logrotate.conf /opt/kaspersky/kuma/mongodb/logrotate/
#RUN chmod 0644 /opt/kaspersky/kuma/mongodb/logrotate/mongo-logrotate.conf
#COPY kuma-core-aio/config/mongodb/cron-logrotate /etc/cron.daily/cron-logrotate
#RUN chmod 0755 /etc/cron.daily/cron-logrotate

#RUN systemctl enable kuma-mongodb.service

#Task: Install Victoria Metrics
#Unarchive directory
    && tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/victoria-metrics.tar.gz" \
    && tar -zxvf kuma-ansible-installer/roles/kuma/files/victoria-metrics.tar.gz \
    && mv victoria-metrics /opt/kaspersky/kuma/ \
#RUN mkdir /opt/kaspersky/kuma/victoria-metrics/cfg/
#Create additional directories
    && mkdir -p /opt/kaspersky/kuma/victoria-metrics/cfg/rules \
    && mkdir -p /opt/kaspersky/kuma/victoria-metrics/cfg/scrape
#Generate configuration file
#COPY kuma-core-aio/config/victoria-metrics/victoria-metrics.yml /opt/kaspersky/kuma/victoria-metrics/cfg/
#Generate systemd services
#COPY kuma-core-aio/config/victoria-metrics/kuma-victoria-metrics.service /etc/systemd/system/
#RUN systemctl enable kuma-victoria-metrics.service
#COPY kuma-core-aio/config/victoria-metrics/kuma-vmalert.service /etc/systemd/system/
#RUN systemctl enable kuma-vmalert.service

#Task: Install Grafana
RUN tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/grafana.tar.gz" \
    && tar -zxvf kuma-ansible-installer/roles/kuma/files/grafana.tar.gz \
    && mv grafana /opt/kaspersky/kuma/
#COPY kuma-core-aio/config/grafana/kuma-grafana.service /etc/systemd/system/
#RUN systemctl enable kuma-grafana.service

#core
RUN tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/kuma" \
#RUN mv kuma-ansible-installer/roles/kuma/files/kuma /opt/kaspersky/kuma/core/bin
    && mv kuma-ansible-installer/roles/kuma/files/kuma /opt/kaspersky/kuma/ \
    && yes | /opt/kaspersky/kuma/kuma license \
#Create Core log directories
    && mkdir -p /opt/kaspersky/kuma/core/log
#RUN mkdir -p /opt/kaspersky/kuma/core/logrotate
#Setup Core log rotation
#COPY kuma-core-aio/config/core/stdout-logrotate.conf /opt/kaspersky/kuma/core/logrotate/
#COPY kuma-core-aio/config/core/stderr-logrotate.conf /opt/kaspersky/kuma/core/logrotate/
#COPY kuma-core-aio/config/core/kuma-core-stdout-log-rotate /etc/cron.weekly/
#COPY kuma-core-aio/config/core/kuma-core-stderr-log-rotate /etc/cron.weekly/


#Create log directory
RUN mkdir -p /var/log/kaspersky/kuma \
    && chmod 0755 /var/log/kaspersky/kuma \
    && chown -R kuma:kuma /var/log/kaspersky/kuma



#COPY kuma-core-aio/scripts/start_core.sh /usr/local/bin

#Not working 
#ENTRYPOINT [ "/usr/local/bin/start_core.sh" ]
#Workaround v1:
#RUN dnf install cronie
#COPY kuma-core-aio/config/cron/run_once /etc/cron.d/
#RUN chmod 400 /etc/cron.d/run_once
#COPY kuma-core-aio/scripts/run_once.sh /usr/local/bin/
#RUN mkdir -p /etc/local/runonce.d/ran
#COPY kuma-core-aio/scripts/start_core.sh /etc/local/runonce.d/
#RUN systemctl enable crond
#Workaround v2:
#COPY kuma-core-aio/config/core/kuma-core-init.service /etc/systemd/system/
COPY kuma-core-aio/rootfs /
#Set ACL for KUMA directory
RUN chown -R kuma:kuma /opt/kaspersky/kuma/ \
    && chmod 0755 /etc/cron.daily/cron-logrotate \
    && chmod 0755 /etc/cron.weekly/kuma-core-stdout-log-rotate \
    && chmod 0755 /etc/cron.weekly/kuma-core-stderr-log-rotate \
    && chmod 0644 /opt/kaspersky/kuma/mongodb/logrotate/mongo-logrotate.conf \
    && chmod 0644 /opt/kaspersky/kuma/core/logrotate/stdout-logrotate.conf \
    && chmod 0644 /opt/kaspersky/kuma/core/logrotate/stderr-logrotate.conf \
    && chmod 0644 /etc/systemd/system/*.service \
    && systemctl enable kuma-core-init.service \
    && systemctl enable kuma-core-init.service \
    && systemctl enable kuma-grafana.service \
    && systemctl enable kuma-mongodb.service \
    && systemctl enable kuma-victoria-metrics.service \
    && systemctl enable kuma-vmalert.service



CMD ["/sbin/init"]

#comment if you need distr in container (for troubleshooting)
#RUN rm -rf /kuma-dist/
#RUN rm -rf /kuma-ansible-installer/