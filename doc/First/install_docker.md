
rm -rf /root/production/*
rm -rf /root/fabric/fabric-samples/config/crypto-config.yaml
rm -rf /root/fabric/fabric-samples/config/configtx.yaml
rm -rf /root/fabric/fabric-samples/docker/* 
rm -rf /root/fabric/fabric-samples/channel-artifacts/*
rm -rf /root/fabric/fabric-samples/crypto-config/*


cd /root/fabric/fabric-samples/bin

./cryptogen generate --config=../config/crypto-config.yaml --output ../crypto-config

./configtxgen -configPath ../config  -profile TwoOrgsOrdererGenesis -channelID fabric-channel -outputBlock ../channel-artifacts/orderer.genesis.block

./configtxgen -configPath ../config  -profile TwoOrgsChannel  -channelID businesschannel -outputCreateChannelTx ../channel-artifacts/businesschannel.tx

./configtxgen -configPath ../config  -profile TwoOrgsChannel -channelID businesschannel -asOrg Org1MSP -outputAnchorPeersUpdate ../channel-artifacts/Org1MSPanchors.tx

./configtxgen -configPath ../config  -profile TwoOrgsChannel -channelID businesschannel -asOrg Org2MSP -outputAnchorPeersUpdate ../channel-artifacts/Org2MSPanchors.tx



cd /root/fabric/fabric-samples/docker

# 部署 orderer 节点
vi docker-compose-3orderer.yaml


## 启动 orderer 节点
#docker-compose -f docker-compose-3orderer.yaml up -d
docker-compose -f docker-compose-1orderer.yaml up -d

docker logs -f orderer0.example.com


# 部署 peer 节点
vi docker-compose-org1-2peer-couchdb.yaml
vi docker-compose-org2-2peer-couchdb.yaml

# 启动 org1 peer 节点
docker-compose -f docker-compose-org1-2peer-couchdb.yaml up -d


# 启动 org2 peer 节点
docker-compose -f docker-compose-org2-2peer-couchdb.yaml up -d


## 如果想停止并且删除服务
#docker-compose -f docker-compose-3orderer.yaml down
docker-compose -f docker-compose-1orderer.yaml down
docker-compose -f docker-compose-org2-2peer-couchdb.yaml down  
docker-compose -f docker-compose-org1-2peer-couchdb.yaml down 

#####################################################################
<!-- ## 服务器中两人同时执行启动脚本后，出错如下：
ERROR: 2 matches found based on name: network product-server_default is ambiguous

### 解决方法
docker network ls

NETWORK ID     NAME             DRIVER    SCOPE
a9c140f4846b   bridge           bridge    local
9ba111b18792   docker_default   bridge    local
ebda04ea6bfc   docker_default   bridge    local
0eff6b5e39d3   fabric-ca        bridge    local
81bddd116fc0   host             host      local
225d1ef27900   none             null      local

### 删除重复的网络
docker network rm 9ba111b18792
docker network rm ebda04ea6bfc


###  移除 docker 挂载的数据卷
docker volume rm $(docker volume ls) -->
#####################################################################



# docker list
fabiric-cli
orderer0.example.com
<!-- orderer1.example.com
orderer2.example.com -->

peer0.org1.example.com
peer1.org1.example.com
peer0.org2.example.com
peer1.org2.example.com

peer0.org1.couchdb
peer1.org1.couchdb
peer0.org2.couchdb
peer1.org2.couchdb




# (！！！出错！！！)
<!-- 挂载文件夹不能相同，否则多个Orderer启动后，使用LevelDB时出现错误，导致只能启动一个服务器 -->



# 创建通道

## 进入 cli 容器：

docker exec -it fabric-cli bash

export APP_CHANNEL=businesschannel
export TIMEOUT=30
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/
peer channel create -o orderer0.example.com:7050 -c ${APP_CHANNEL} -f "/tmp/channel-artifacts/$APP_CHANNEL.tx" --timeout "${TIMEOUT}s"
<!-- 

peer channel create -o orderer0.example.com:7050 -c ${APP_CHANNEL} -f "/tmp/channel-artifacts/$APP_CHANNEL.tx" --timeout "${TIMEOUT}s" --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

peer channel create -o orderer0.example.com:7050 -c ${APP_CHANNEL} -f "/tmp/channel-artifacts/$APP_CHANNEL.tx" --timeout "${TIMEOUT}s" --tls --cafile /etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/tlscacerts/tlsca.org1.example.com-cert.pem

export CORE_PEER_LOCALMSPID=OrdererMSP
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp


peer channel create -o orderer0.example.com:7050 -c ${APP_CHANNEL} -f "/tmp/channel-artifacts/$APP_CHANNEL.tx" --timeout "${TIMEOUT}s" --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -->


## 创建成功后会在当前路径下生成 businesschannel.block 文件。
mv businesschannel.block /tmp/channel-artifacts/


# 加入通道

## 进入 cli 容器
docker exec -it fabric-cli bash

## org1-peer0 加入通道：
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

peer channel join -b /tmp/channel-artifacts/businesschannel.block

### 结果如下：
<!-- [020 02-18 03:57:28.30 UTC] [channelCmd] executeJoin -> INFO Successfully submitted proposal to join channel -->

## org1-peer1 加入通道：
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer1.org1.example.com:8051


peer channel join -b /tmp/channel-artifacts/businesschannel.block

## org2-peer0 加入通道：
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051

peer channel join -b /tmp/channel-artifacts/businesschannel.block

## org2-peer1 加入通道：
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/users/Admin\@org2.example.com/msp
export CORE_PEER_ADDRESS=peer1.org2.example.com:10051

peer channel join -b /tmp/channel-artifacts/businesschannel.block




# 更新锚节点
## org1 更新锚节点：
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin\@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

<!-- peer channel update -o orderer0.example.com:7050 -c businesschannel -f /tmp/channel-artifacts/Org1MSPanchors.tx --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -->
peer channel update -o orderer0.example.com:7050 -c businesschannel -f /tmp/channel-artifacts/Org1MSPanchors.tx


## org2 更新锚节点：
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/users/Admin\@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051

<!-- peer channel update -o orderer0.example.com:7050 -c businesschannel -f /tmp/channel-artifacts/Org2MSPanchors.tx --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -->
peer channel update -o orderer0.example.com:7050 -c businesschannel -f /tmp/channel-artifacts/Org2MSPanchors.tx 

#### 锚节点配置更新后，同一通道内不同组织之间的 Peer 也可以进行 Gossip 通信，共同维护通道账本。后续，用户可以通过智能合约使用通道账本。


# !!却换到 org1-peer0 节点 !!
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin\@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051


# 安装链码

 yum install -y java-1.8.0-openjdk


## 进入 cli 容器：
docker exec -it fabric-cli bash

## 在宿主机和 docker cli 容器挂载的 chaincodes 目录下下载合约代码：
git clone https://gitee.com/kernelHP/hyperledger-fabric-contract-java-demo.git

cd hyperledger-fabric-contract-java-demo/

### 编译打包源码：
mvn compile package -DskipTests -Dmaven.test.skip=true

mv target/chaincode.jar $PWD

### 删除编译后产生的 target 目录； src 源代码目录； pom.xml
rm -rf target/ src pom.xml

### 打包链码
<!-- peer lifecycle chaincode package card-contract.tar.gz --path ./card-contract/ --lang java --label card-contract_1 -->
 peer lifecycle chaincode package card-contract.tar.gz --path /etc/hyperledger/fabric/chaincode/cardcontract/ --lang java --label card-contract_1




export PACKAGE_FILE=card-constrct.tar.gz
exposrt


## 在 peer 节点安装链码
cd /etc/hyperledger/fabric/chaincodes/

### org1-peer0 节点：
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin\@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

<!-- peer lifecycle chaincode install hyperledger-fabric-contract-java-demo.tar.gz -->
peer lifecycle chaincode install card-contract.tar.gz

<!-- #### 结果如下： 
[020 02-18 03:26:06.78 UTC] [cli.lifecycle.chaincode] submitInstallProposal -> INFO Installed remotely: response:<status:200 payload:"\nhhyperledger-fabric-contract-java-demo_1:bbc6a881b7cf349cd608a608d32e638b546341575e48614524761ab51fc6a457\022'hyperledger-fabric-contract-java-demo_1" > 
[021 02-18 03:26:06.78 UTC] [cli.lifecycle.chaincode] submitInstallProposal -> INFO Chaincode code package identifier: hyperledger-fabric-contract-java-demo_1:bbc6a881b7cf349cd608a608d32e638b546341575e48614524761ab51fc6a457 -->

### org1-peer1 节点:
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin\@org1.example.com/msp
export CORE_PEER_ADDRESS=peer1.org1.example.com:8051

<!-- peer lifecycle chaincode install hyperledger-fabric-contract-java-demo.tar.gz -->
peer lifecycle chaincode install card-contract.tar.gz

### org2-peer0 节点:
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/users/Admin\@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051

<!-- peer lifecycle chaincode install hyperledger-fabric-contract-java-demo.tar.gz -->
peer lifecycle chaincode install card-contract.tar.gz

### org2-peer1 节点:
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/users/Admin\@org2.example.com/msp
export CORE_PEER_ADDRESS=peer1.org2.example.com:10051

<!-- peer lifecycle chaincode install hyperledger-fabric-contract-java-demo.tar.gz -->
peer lifecycle chaincode install card-contract.tar.gz


### 查询包 ID:
peer lifecycle chaincode queryinstalled

 <!-- #### 包 ID 是链码标签和链码二进制文件的哈希值的组合。每个 peer 节点将生成相同的包 ID。你应该看到类似于以下内容的输出：
Installed chaincodes on peer:
Package ID: card-contract_1:cb55c34902fa4114a0fcb7f5cea742e8f5ec69786f12305cdec01457fb1fe4e2, Label: card-contract_1 -->


#### 将包 ID 保存为环境变量:
export CC_PACKAGE_ID=card-contract_1:cb55c34902fa4114a0fcb7f5cea742e8f5ec69786f12305cdec01457fb1fe4e2


# 批准链码定义

## org1 批准链码定义:
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

<!-- peer lifecycle chaincode approveformyorg -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --channelID businesschannel --name hyperledger-fabric-contract-java-demo --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -->

peer lifecycle chaincode approveformyorg -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --channelID businesschannel --name card-contract --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1

#### 结果如下：
[025 02-18 05:37:12.44 UTC] [chaincodeCmd] ClientWait -> INFO txid [895c0d4b9eee30419e068072b816906f660c1f9ddb7400b63d6892a001470c38] committed with status (VALID) at peer0.org1.example.com:7051

## org2 批准链码定义:
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051

<!-- peer lifecycle chaincode approveformyorg -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --channelID businesschannel --name hyperledger-fabric-contract-java-demo --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -->

peer lifecycle chaincode approveformyorg -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --channelID businesschannel --name card-contract --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1


### 检查通道成员是否已批准相同的链码定义：
<!-- peer lifecycle chaincode checkcommitreadiness --channelID businesschannel --name hyperledger-fabric-contract-java-demo --version 1.0 --sequence 1 --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --output json -->
peer lifecycle chaincode checkcommitreadiness --channelID businesschannel --name card-contract --version 1.0 --sequence 1 --output json

#### 输出结果如下：
{
	"approvals": {
		"Org1MSP": true,
		"Org2MSP": true
	}
}

## 将链码提交到通道:
<!-- peer lifecycle chaincode commit -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --channelID businesschannel --name hyperledger-fabric-contract-java-demo --version 1.0 --sequence 1 --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses peer0.org2.example.com:7051 --tlsRootCertFiles /etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -->

peer lifecycle chaincode commit -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --channelID businesschannel --name card-contract --version 1.0 --sequence 1 --peerAddresses peer0.org1.example.com:7051 --peerAddresses peer0.org2.example.com:9051 

#### 结果如下：
[029 02-18 05:50:47.62 UTC] [chaincodeCmd] ClientWait -> INFO txid [2c06365cd94ebcc95e4fc6e5a5334aafda35e874bf894ef604fd3a9fe18d86be] committed with status (VALID) at peer0.org2.example.com:7051
[02a 02-18 05:50:47.81 UTC] [chaincodeCmd] ClientWait -> INFO txid [2c06365cd94ebcc95e4fc6e5a5334aafda35e874bf894ef604fd3a9fe18d86be] committed with status (VALID) at peer0.org1.example.com:7051

### 用 peer lifecycle chaincode querycommitted 命令来确认链码定义已提交给通道:
<!-- peer lifecycle chaincode querycommitted --channelID businesschannel --name hyperledger-fabric-contract-java-demo --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -->
peer lifecycle chaincode querycommitted --channelID businesschannel --name card-contract

#### 结果如下：
Committed chaincode definition for chaincode 'hyperledger-fabric-contract-java-demo' on channel 'businesschannel':
Version: 1.0, Sequence: 1, Endorsement Plugin: escc, Validation Plugin: vscc, Approvals: [Org1MSP: true, Org2MSP: true]



# 调用链码

## 调用 createCard 函数
<!-- peer chaincode invoke -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C businesschannel -n hyperledger-fabric-contract-java-demo --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses peer0.org2.example.com:7051 --tlsRootCertFiles /etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"createCat","Args":["cat-0" , "tom" ,  "3" , "蓝色" , "大懒猫"]}' -->

peer chaincode invoke -o orderer0.example.com:7050 -C businesschannel -n card-contract --peerAddresses peer0.org1.example.com:7051 --peerAddresses peer0.org2.example.com:9051 -c '{"function":"createCard","Args":["111" , "222" ,  "3333" , "444" , "5555"]}'

## 调用 getCard 函数
<!-- peer chaincode query -C businesschannel -n hyperledger-fabric-contract-java-demo -c '{"Args":["queryCat" , "cat-0"]}' -->
peer chaincode query -C businesschannel -n card-contract -c '{"Args":["getCard" , "111"]}'




