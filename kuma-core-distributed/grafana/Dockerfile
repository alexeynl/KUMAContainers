FROM oraclelinux:9
COPY resources/kuma-dis[t]/kuma-ansible-installer-3.0.2.37.tar.gz kuma-dis[t]/kuma-ansible-installer-3.0.2.37.tar.gz /kuma-dist/
#common prerequisites
RUN dnf install hostname \
#Create KUMA service user
    && useradd --system kuma && usermod -s /usr/bin/false kuma \

#Task: Install Grafana
    && tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/grafana.tar.gz" \
    && tar -zxvf kuma-ansible-installer/roles/kuma/files/grafana.tar.gz \
    && mv grafana /opt/
COPY kuma-core-distributed/grafana/rootfs /
#COPY kuma-core-distributed/grafana/config/kuma-grafana.service /etc/systemd/system/
RUN chmod 0644 /etc/systemd/system/*.service \
    && systemctl enable kuma-grafana.service \
#Set ACL for Grafana directory
    && chown -R kuma:kuma /opt/grafana

#Change Graphana listen address in config
#RUN sed -c -i "s/\(http_addr *= *\).*/\10.0.0.0/" /opt/grafana/conf/defaults.ini
#Adopt config to remote Victoria Metrics
#RUN sed -c -i "s/\(url: *\).*/\1http:\\/\\/kuma-victoria-01:9090/" /opt/grafana/conf/provisioning/datasources/default.yaml
#Adopt config to new path
#RUN sed -c -i "s/\(path: *\).*/\1\\/opt\\/grafana\\/conf\\/dashboards/" /opt/grafana/conf/provisioning/dashboards/default.yaml

CMD ["/sbin/init"]

#comment if you need distr in container (for troubleshooting)
#RUN rm -rf /kuma-dist/
#RUN rm -rf /kuma-ansible-installer/