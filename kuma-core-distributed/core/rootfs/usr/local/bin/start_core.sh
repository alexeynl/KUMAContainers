#!/bin/bash

#Start MongoDB
#systemctl enable kuma-mongodb
#systemctl start kuma-mongodb

#Initialize MongoDB replica set
sleep 5
/opt/kaspersky/kuma/mongodb/bin/mongo --eval 'rs.initiate()'

#Core --install (new-installation-actions.yml)
/opt/kaspersky/kuma/kuma core --install  --mongo mongodb://kuma-mongodb-01:27017

#Copy certificates for Victoria Metrics

cp -r /opt/kaspersky/kuma/core/certificates/* /opt/kuma-core-certs
chown -R kuma:kuma /opt/kuma-core-certs
