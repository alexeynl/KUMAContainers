FROM oraclelinux:9
COPY resources/kuma-dis[t]/kuma-ansible-installer-3.0.2.37.tar.gz kuma-dis[t]/kuma-ansible-installer-3.0.2.37.tar.gz /kuma-dist/
#common prerequisites
RUN dnf install hostname \

    && useradd --system kuma && usermod -s /usr/bin/false kuma \
    && mkdir -p /opt/kaspersky/kuma/ \

#Place KUMA package
    && tar -zxvf /kuma-dist/kuma-ansible-installer-3.0.2.37.tar.gz --wildcards "*/kuma/files/kuma" \
    && mv /kuma-ansible-installer/roles/kuma/files/kuma /opt/kaspersky/kuma/ \

#Set ACL for KUMA home directory
    && chown -R kuma:kuma /opt/kaspersky/kuma/

#comment if you need distr in container (for troubleshooting)
#RUN rm -rf /kuma-dist/
#RUN rm -rf /kuma-ansible-installer/

CMD ["/sbin/init"]