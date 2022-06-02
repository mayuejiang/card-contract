#!/bin/bash


rm -rf /root/fabric/fabric-samples/config/crypto-config.yaml
rm -rf /root/fabric/fabric-samples/config/configtx.yaml
rm -rf /root/fabric/fabric-samples/channel-artifacts/*
rm -rf /root/fabric/fabric-samples/crypto-config/*

docker volume rm $(docker volume ls)
rm -rf /root/production/*

#rm -rf /root/fabric/fabric-samples/docker/* 

