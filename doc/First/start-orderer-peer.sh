#!/bin/bash


docker-compose -f docker-compose-3orderer.yaml up -d
docker-compose -f docker-compose-org1-2peer-couchdb.yaml up -d
docker-compose -f docker-compose-org2-2peer-couchdb.yaml up -d

