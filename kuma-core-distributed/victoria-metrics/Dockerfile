FROM oraclelinux:9
COPY resources/kuma-dis[t]/kuma-ansible-installer-3.0.2.37.tar.gz kuma-dis[t]/kuma-ansible-installer-3.0.2.37.tar.gz /kuma-dist/
#common prerequisites
RUN dnf install hostname \
#Create KUMA service user
    && useradd --system kuma && usermod -s /usr/bin/false kuma \
#Task: Install Victoria Metrics
#Unarchive directory
    && tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/victoria-metrics.tar.gz" \
    && tar -zxvf kuma-ansible-installer/roles/kuma/files/victoria-metrics.tar.gz \
    && mv victoria-metrics /opt/ \
    && mkdir /opt/victoria-metrics/cfg/ \
#Create additional directories
    && mkdir /opt/victoria-metrics/cfg/rules \
    && mkdir /opt/victoria-metrics/cfg/scrape
#Generate configuration file
#COPY kuma-core-distributed/victoria-metrics/config/victoria-metrics.yml /opt/victoria-metrics/cfg/
#Generate systemd services
COPY kuma-core-distributed/victoria-metrics/rootfs /
RUN chmod 644 /etc/systemd/system/kuma-victoria-metrics.service \
    && chmod 644 /etc/systemd/system/kuma-vmalert.service \
    && systemctl enable kuma-victoria-metrics.service \
    && systemctl enable kuma-vmalert.service \
#COPY kuma-core-distributed/victoria-metrics/config/kuma-victoria-metrics.service /etc/systemd/system/
#RUN systemctl enable kuma-victoria-metrics.service
#COPY kuma-core-distributed/victoria-metrics/config/kuma-vmalert.service /etc/systemd/system/
#RUN systemctl enable kuma-vmalert.service

#Set ACL for KUMA directory
    && chown -R kuma:kuma /opt/victoria-metrics \

#Create certs directory
    && mkdir -p /opt/kaspersky/kuma/core/certificates/
#Create scrape config directories
    #&& mkdir -p /opt/kaspersky/kuma/victoria-metrics/cfg/scrape \
    #&& chown -R kuma:kuma /opt/kaspersky

CMD ["/sbin/init"]

#comment if you need distr in container (for troubleshooting)
#RUN rm -rf /kuma-dist/
#RUN rm -rf /kuma-ansible-installer/