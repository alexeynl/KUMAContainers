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

#core
RUN tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/kuma"
#RUN mv kuma-ansible-installer/roles/kuma/files/kuma /opt/kaspersky/kuma/core/bin
RUN mv kuma-ansible-installer/roles/kuma/files/kuma /opt/kaspersky/kuma/
RUN yes | /opt/kaspersky/kuma/kuma license
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

#Setup HAProxy to redirect KUMA Core requests to Graphana and Victoria Metrics from localhost to remote hosts
RUN dnf install haproxy
COPY kuma-core-distributed/core/config/haproxy.cfg /etc/haproxy/haproxy.cfg
RUN systemctl enable haproxy.service

#Create log directory
RUN mkdir -p /var/log/kaspersky/kuma
RUN chmod 0755 /var/log/kaspersky/kuma
RUN chown -R kuma:kuma /var/log/kaspersky/kuma

#Set ACL for KUMA directory
RUN chown -R kuma:kuma /opt/kaspersky/kuma/

COPY kuma-core-distributed/core/scripts/start_core.sh /usr/local/bin

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
COPY kuma-core-aio/config/core/kuma-core-init.service /etc/systemd/system/
RUN systemctl enable kuma-core-init.service

#Create directory for certificates to share with Victoria Metrics
RUN mkdir -p /opt/kuma-core-certs
RUN mkdir -p /opt/victoria-metrics/cfg/scrape/
RUN chown -R kuma:kuma /opt/victoria-metrics

CMD ["/sbin/init"]

#comment if you need distr in container (for troubleshooting)
#RUN rm -rf /kuma-dist/
#RUN rm -rf /kuma-ansible-installer/