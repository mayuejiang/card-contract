#!/bin/bash


cp crypto-config.yaml ../config/crypto-config.yaml
cp configtx.yaml ../config/configtx.yaml

../bin/cryptogen generate --config=../config/crypto-config.yaml --output ../crypto-config

../bin/configtxgen -configPath ../config  -profile TwoOrgsOrdererGenesis -channelID fabric-channel -outputBlock ../channel-artifacts/orderer.genesis.block

../bin/configtxgen -configPath ../config  -profile TwoOrgsChannel  -channelID businesschannel -outputCreateChannelTx ../channel-artifacts/businesschannel.tx

../bin/configtxgen -configPath ../config  -profile TwoOrgsChannel -channelID businesschannel -asOrg Org1MSP -outputAnchorPeersUpdate ../channel-artifacts/Org1MSPanchors.tx

../bin/configtxgen -configPath ../config  -profile TwoOrgsChannel -channelID businesschannel -asOrg Org2MSP -outputAnchorPeersUpdate ../channel-artifacts/Org2MSPanchors.tx
