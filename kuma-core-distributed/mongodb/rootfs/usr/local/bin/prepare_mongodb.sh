#!/bin/bash

#Initialize MongoDB replica set
sleep 5
/opt/mongodb/bin/mongo --eval 'rs.initiate()'
