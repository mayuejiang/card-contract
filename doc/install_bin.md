生成身份信息文件：https://my.oschina.net/j4love/blog/5453756
二进制文件部署 orderer 节点 ：https://my.oschina.net/j4love/blog/5454092
二进制文件部署 peer 节点 ： https://my.oschina.net/j4love/blog/5458418

# 1 生成身份信息文件

节点	    宿主机 IP	    hosts	                端口
cli	        192.168.0.137	N/A	                    N/A
orderer0	192.168.0.137	orderer0.example.com	7050
orderer1	192.168.0.137	orderer1.example.com	8050
orderer2	192.168.0.137	orderer2.example.com	9050
org1-peer0	192.168.0.137	peer0.org1.example.com	7051
org1-peer1	192.168.0.137	peer1.org1.example.com	8051
org2-peer0	192.168.0.137	peer0.org2.example.com	7051
org2-peer1	192.168.0.137	peer1.org2.example.com	8051

```
vim /etc/hosts
192.168.0.137 orderer0.example.com
192.168.0.137 orderer1.example.com
192.168.0.137 orderer2.example.com

192.168.0.137 peer0.org1.example.com
192.168.0.137 peer1.org1.example.com

192.168.0.137 peer0.org2.example.com
192.168.0.137 peer1.org2.example.com
```


./cryptogen showtemplate > ../crypto-config.yaml
vi ../config/configtx.yaml
 

./cryptogen generate --config=../config/crypto-config.yaml --output ../crypto-config

./configtxgen -configPath ../config  -profile TwoOrgsOrdererGenesis -channelID fabric-channel -outputBlock ../channel-artifacts/orderer.genesis.block

./configtxgen -configPath ../config  -profile TwoOrgsChannel  -channelID businesschannel -outputCreateChannelTx ../channel-artifacts/businesschannel.tx

./configtxgen -configPath ../config  -profile TwoOrgsChannel -channelID businesschannel -asOrg Org1MSP -outputAnchorPeersUpdate ../channel-artifacts/Org1MSPanchors.tx

./configtxgen -configPath ../config  -profile TwoOrgsChannel -channelID businesschannel -asOrg Org2MSP -outputAnchorPeersUpdate ../channel-artifacts/Org2MSPanchors.tx







# 2 orderer 节点

节点	    宿主机 IP	    hosts	                端口
cli         192.168.0.137	N/A	                    N/A
orderer0	192.168.0.137	orderer0.example.com	7050 , 8443 , 9443
orderer1	192.168.0.137	orderer1.example.com	8050 , 8444 , 9444
orderer2	192.168.0.137	orderer2.example.com	9050 , 8445 , 9445

## orderer0
[root@ecs-e320 fabric-samples]# mkdir orderer0
[root@ecs-e320 fabric-samples]# cp bin/orderer config/orderer.yaml orderer0/
[root@ecs-e320 fabric-samples]# cd orderer0/
[root@ecs-e320 orderer0]# ls
orderer  orderer.yaml
[root@ecs-e320 orderer0]# vi orderer.yaml

[root@ecs-e320 orderer0]# nohup ./orderer start > orderer0-log.log 2>&1 &
tail -f orderer0-log.log

## orderer1
[root@ecs-e320 orderer0]# mkdir ../orderer1
[root@ecs-e320 orderer0]# cd ../orderer1
[root@ecs-e320 orderer1]# cp orderer orderer.yaml ../orderer1/
[root@ecs-e320 orderer1]# vi orderer.yaml
[root@ecs-e320 orderer1]# nohup ./orderer start > orderer1-log.log 2>&1 &
tail -f orderer1-log.log

## orderer2
[root@ecs-e320 orderer1]# mkdir ../orderer2
[root@ecs-e320 orderer1]# cd ../orderer2
[root@ecs-e320 orderer2]# cp orderer orderer.yaml ../orderer2/
[root@ecs-e320 orderer2]# nohup ./orderer start > orderer2-log.log 2>&1 &
tail -f orderer2-log.log


ps -aux |grep orderer



# 3 peer 节点

节点	    宿主机 IP	    hosts	                端口
cli	        192.168.0.137	N/A	                    N/A
orderer0	192.168.0.137	orderer0.example.com	7050 , 8443 ， 9443
orderer1	192.168.0.137	orderer1.example.com	8050 , 8444 ，9444
orderer2	192.168.0.137	orderer2.example.com	9050 , 8445 ，9445
org1-peer0	192.168.0.137	peer0.org1.example.com	7051 , 7052 , 9446 , 8125
org1-peer1	192.168.0.137	peer1.org1.example.com	8051 , 8052 , 9447 , 8126
org2-peer0	192.168.0.137	peer0.org2.example.com	9051 , 9052 , 9448 , 8127
org2-peer1	192.168.0.137	peer1.org2.example.com	10051 , 10052 , 9449 , 8128

## org1-peer0
cd org1-peer0
vi core.yaml
nohup ./peer node start > org1-peer0.log 2>&1 &
tail -f org1-peer0.log

## org1-peer1
cd org1-peer1
vi core.yaml
nohup ./peer node start > org1-peer1.log 2>&1 &
tail -f org1-peer1.log

## org1-peer0
cd org2-peer0
vi core.yaml
nohup ./peer node start > org2-peer0.log 2>&1 &
tail -f org2-peer0.log

## org2-peer1
cd org2-peer1
vi core.yaml
nohup ./peer node start > org2-peer1.log 2>&1 &
tail -f org2-peer1.log

ps -aux |grep peer




cd /root/fabric/fabric-samples/org1-peer0

# 创建通道
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_MSPCONFIGPATH=/root/fabric/fabric-samples/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

./peer channel create -o orderer0.example.com:7050 -c businesschannel -f "/root/fabric/fabric-samples/channel-artifacts/businesschannel.tx" --timeout "30s" --tls --cafile /root/fabric/fabric-samples/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

## 创建成功后会在当前路径下生成 businesschannel.block 文件。
mv businesschannel.block /root/fabric/fabric-samples/channel-artifacts


# 加入通道

## org1-peer0 加入通道
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/root/fabric/fabric-samples/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/root/fabric/fabric-samples/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

./peer channel join -b /root/fabric/fabric-samples/channel-artifacts/businesschannel.block

## 加入成功可以看到如下输出：
2022-02-22 08:58:09.295 EST 0002 INFO [channelCmd] executeJoin -> Successfully submitted proposal to join channel


# org1-peer1 加入通道
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/root/fabric/fabric-samples/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/root/fabric/fabric-samples/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer1.org1.example.com:8051

./peer channel join -b /root/fabric/fabric-samples/channel-artifacts/businesschannel.block

# org2-peer0 加入通道
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/root/fabric/fabric-samples/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/root/fabric/fabric-samples/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051

./peer channel join -b /root/fabric/fabric-samples/channel-artifacts/businesschannel.block

# org2-peer1 加入通道
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/root/fabric/fabric-samples/crypto-config/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/root/fabric/fabric-samples/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer1.org2.example.com:10051

./peer channel join -b /root/fabric/fabric-samples/channel-artifacts/businesschannel.block

# 查看 peer 节点加入的通道

./peer channel list

## 输出如下：
2022-02-22 09:03:02.681 EST 0001 INFO [channelCmd] InitCmdFactory -> Endorser and orderer connections initialized
Channels peers has joined: 
businesschannel

