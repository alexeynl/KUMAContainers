FROM oraclelinux:9
COPY resources/kuma-dis[t]/kuma-ansible-installer-3.0.2.37.tar.gz kuma-dis[t]/kuma-ansible-installer-3.0.2.37.tar.gz /kuma-dist/
#common prerequisites
RUN dnf install hostname
#Create KUMA service user
RUN useradd --system kuma && usermod -s /usr/bin/false kuma
#Create vendor directory
#Create KUMA directory
RUN mkdir -p /opt/kaspersky/kuma/core/bin/

#Task: Install Kuma Updater
#core/kuma-updater.yml
#Unarchive directory
RUN tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/kuma-updater.tar.gz"
RUN tar -zxvf /kuma-ansible-installer/roles/kuma/files/kuma-updater.tar.gz
RUN mv kuma-updater /opt/kaspersky/kuma/

#Task: Install MongoDB
#core/mongodb.yml
#Unarchive directory
RUN dnf install compat-openssl11.x86_64
RUN tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/mongodb.tar.gz"
RUN tar -zxvf kuma-ansible-installer/roles/kuma/files/mongodb.tar.gz
RUN mv mongodb /opt/kaspersky/kuma/
#Create additional directories
RUN mkdir /opt/kaspersky/kuma/mongodb/cfg
RUN mkdir /opt/kaspersky/kuma/mongodb/data
RUN mkdir /opt/kaspersky/kuma/mongodb/log
RUN mkdir /opt/kaspersky/kuma/mongodb/logrotate
#Generate configuration file
COPY kuma-core-aio/config/mongodb/mongod.conf /opt/kaspersky/kuma/mongodb/cfg/
#Generate systemd service
COPY kuma-core-aio/config/mongodb/kuma-mongodb.service /etc/systemd/system/
#Setup mongodb log rotation
RUN dnf install logrotate
COPY kuma-core-aio/config/mongodb/mongo-logrotate.conf /opt/kaspersky/kuma/mongodb/logrotate/
RUN chmod 0644 /opt/kaspersky/kuma/mongodb/logrotate/mongo-logrotate.conf
COPY kuma-core-aio/config/mongodb/cron-logrotate /etc/cron.daily/cron-logrotate
RUN chmod 0755 /etc/cron.daily/cron-logrotate

RUN systemctl enable kuma-mongodb.service

#Task: Install Victoria Metrics
#Unarchive directory
RUN tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/victoria-metrics.tar.gz"
RUN tar -zxvf kuma-ansible-installer/roles/kuma/files/victoria-metrics.tar.gz
RUN mv victoria-metrics /opt/kaspersky/kuma/
RUN mkdir /opt/kaspersky/kuma/victoria-metrics/cfg/
#Create additional directories
RUN mkdir /opt/kaspersky/kuma/victoria-metrics/cfg/rules
RUN mkdir /opt/kaspersky/kuma/victoria-metrics/cfg/scrape
#Generate configuration file
COPY kuma-core-aio/config/victoria-metrics/victoria-metrics.yml /opt/kaspersky/kuma/victoria-metrics/cfg/
#Generate systemd services
COPY kuma-core-aio/config/victoria-metrics/kuma-victoria-metrics.service /etc/systemd/system/
RUN systemctl enable kuma-victoria-metrics.service
COPY kuma-core-aio/config/victoria-metrics/kuma-vmalert.service /etc/systemd/system/
RUN systemctl enable kuma-vmalert.service

#Task: Install Grafana
RUN tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/grafana.tar.gz"
RUN tar -zxvf kuma-ansible-installer/roles/kuma/files/grafana.tar.gz
RUN mv grafana /opt/kaspersky/kuma/
COPY kuma-core-aio/config/grafana/kuma-grafana.service /etc/systemd/system/
RUN systemctl enable kuma-grafana.service

#core
RUN tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/kuma"
#RUN mv kuma-ansible-installer/roles/kuma/files/kuma /opt/kaspersky/kuma/core/bin
RUN mv kuma-ansible-installer/roles/kuma/files/kuma /opt/kaspersky/kuma/
#Create Core log directories
RUN mkdir -p /opt/kaspersky/kuma/core/log
RUN mkdir -p /opt/kaspersky/kuma/core/logrotate
#Setup Core log rotation
COPY kuma-core-aio/config/core/stdout-logrotate.conf /opt/kaspersky/kuma/core/logrotate/
COPY kuma-core-aio/config/core/stderr-logrotate.conf /opt/kaspersky/kuma/core/logrotate/
RUN chmod 0644 /opt/kaspersky/kuma/core/logrotate/stdout-logrotate.conf
RUN chmod 0644 /opt/kaspersky/kuma/core/logrotate/stderr-logrotate.conf
COPY kuma-core-aio/config/core/kuma-core-stdout-log-rotate /etc/cron.weekly/
COPY kuma-core-aio/config/core/kuma-core-stderr-log-rotate /etc/cron.weekly/
RUN chmod 0755 /etc/cron.weekly/kuma-core-stdout-log-rotate
RUN chmod 0755 /etc/cron.weekly/kuma-core-stderr-log-rotate

#Create log directory
RUN mkdir -p /var/log/kaspersky/kuma
RUN chmod 0755 /var/log/kaspersky/kuma
RUN chown -R kuma:kuma /var/log/kaspersky/kuma

#Set ACL for KUMA directory
RUN chown -R kuma:kuma /opt/kaspersky/kuma/

COPY kuma-core-aio/scripts/start_core.sh /usr/local/bin

#Not working 
#ENTRYPOINT [ "/usr/local/bin/start_core.sh" ]
#Workaround:
RUN dnf install cronie
COPY kuma-core-aio/config/cron/run_once /etc/cron.d/
RUN chmod 400 /etc/cron.d/run_once
COPY kuma-core-aio/scripts/run_once.sh /usr/local/bin/
RUN mkdir -p /etc/local/runonce.d/ran
COPY kuma-core-aio/scripts/start_core.sh /etc/local/runonce.d/
RUN systemctl enable crond

CMD ["/sbin/init"]

#comment if you need distr in container (for troubleshooting)
#RUN rm -rf /kuma-dist/
#RUN rm -rf /kuma-ansible-installer/