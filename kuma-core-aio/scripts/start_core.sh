#!/bin/bash

#Start MongoDB
#systemctl enable kuma-mongodb
#systemctl start kuma-mongodb

#Initialize MongoDB replica set
sleep 20
/opt/kaspersky/kuma/mongodb/bin/mongo --eval 'rs.initiate()'

#Core --install (new-installation-actions.yml)
yes | /opt/kaspersky/kuma/kuma core --install