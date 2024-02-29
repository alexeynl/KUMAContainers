FROM oraclelinux:9
COPY resources/kuma-dis[t]/kuma-ansible-installer-3.0.2.37.tar.gz kuma-dis[t]/kuma-ansible-installer-3.0.2.37.tar.gz /kuma-dist/
#common prerequisites
RUN dnf install hostname
#Create KUMA service user
RUN useradd --system kuma && usermod -s /usr/bin/false kuma

#Task: Install Victoria Metrics
#Unarchive directory
RUN tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/victoria-metrics.tar.gz"
RUN tar -zxvf kuma-ansible-installer/roles/kuma/files/victoria-metrics.tar.gz
RUN mv victoria-metrics /opt/
RUN mkdir /opt/victoria-metrics/cfg/
#Create additional directories
RUN mkdir /opt/victoria-metrics/cfg/rules
RUN mkdir /opt/victoria-metrics/cfg/scrape
#Generate configuration file
COPY kuma-core-distributed/victoria-metrics/config/victoria-metrics.yml /opt/victoria-metrics/cfg/
#Generate systemd services
COPY kuma-core-distributed/victoria-metrics/config/kuma-victoria-metrics.service /etc/systemd/system/
RUN systemctl enable kuma-victoria-metrics.service
COPY kuma-core-distributed/victoria-metrics/config/kuma-vmalert.service /etc/systemd/system/
RUN systemctl enable kuma-vmalert.service

#Set ACL for KUMA directory
RUN chown -R kuma:kuma /opt/victoria-metrics

#Create certs directory
RUN mkdir -p /opt/kaspersky/kuma/core/certificates/

RUN mkdir -p /opt/kaspersky/kuma/victoria-metrics/cfg/scrape
RUN chown -R kuma:kuma /opt/kaspersky

CMD ["/sbin/init"]

#comment if you need distr in container (for troubleshooting)
#RUN rm -rf /kuma-dist/
#RUN rm -rf /kuma-ansible-installer/