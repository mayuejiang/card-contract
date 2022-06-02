
<!-- export CODE_NAME=card-constrct -->
export CODE_NAME=hyperledger-fabric-contract-java-demo


### �ŕ�??
 <!-- peer lifecycle chaincode package card-contract.tar.gz --path /etc/hyperledger/fabric/chaincode/cardcontract/ --lang java --label card-contract_1 -->
 peer lifecycle chaincode package ${CODE_NAME}.tar.gz --path /etc/hyperledger/fabric/chaincode/${CODE_NAME}/ --lang java --label ${CODE_NAME}_1



exposrt


## �� peer ?�_����??
cd /etc/hyperledger/fabric/chaincode/

### org1-peer0 ?�_�F
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin\@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

<!-- peer lifecycle chaincode install hyperledger-fabric-contract-java-demo.tar.gz -->
<!-- peer lifecycle chaincode install card-contract.tar.gz -->
peer lifecycle chaincode install ${CODE_NAME}.tar.gz

<!-- #### ?�ʔ@���F 
[020 02-18 03:26:06.78 UTC] [cli.lifecycle.chaincode] submitInstallProposal -> INFO Installed remotely: response:<status:200 payload:"\nhhyperledger-fabric-contract-java-demo_1:bbc6a881b7cf349cd608a608d32e638b546341575e48614524761ab51fc6a457\022'hyperledger-fabric-contract-java-demo_1" > 
[021 02-18 03:26:06.78 UTC] [cli.lifecycle.chaincode] submitInstallProposal -> INFO Chaincode code package identifier: hyperledger-fabric-contract-java-demo_1:bbc6a881b7cf349cd608a608d32e638b546341575e48614524761ab51fc6a457 -->

### org1-peer1 ?�_:
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin\@org1.example.com/msp
export CORE_PEER_ADDRESS=peer1.org1.example.com:8051

<!-- peer lifecycle chaincode install hyperledger-fabric-contract-java-demo.tar.gz -->
<!-- peer lifecycle chaincode install card-contract.tar.gz -->
peer lifecycle chaincode install ${CODE_NAME}.tar.gz

### org2-peer0 ?�_:
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/users/Admin\@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051

<!-- peer lifecycle chaincode install hyperledger-fabric-contract-java-demo.tar.gz -->
<!-- peer lifecycle chaincode install card-contract.tar.gz -->
peer lifecycle chaincode install ${CODE_NAME}.tar.gz

### org2-peer1 ?�_:
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/users/Admin\@org2.example.com/msp
export CORE_PEER_ADDRESS=peer1.org2.example.com:10051

<!-- peer lifecycle chaincode install hyperledger-fabric-contract-java-demo.tar.gz -->
<!-- peer lifecycle chaincode install card-contract.tar.gz -->
peer lifecycle chaincode install ${CODE_NAME}.tar.gz

### ??�� ID:
peer lifecycle chaincode queryinstalled

 <!-- #### �� ID ��????�a??��?�������I����?�I?���B?�� peer ?�_�����������I�� ID�B???�œ�?�����ȉ����e�I?�o�F
Installed chaincodes on peer:
Package ID: card-contract_1:cb55c34902fa4114a0fcb7f5cea742e8f5ec69786f12305cdec01457fb1fe4e2, Label: card-contract_1 -->


#### ���� ID �ۑ�??��?��:
<!-- export CC_PACKAGE_ID=card-contract_1:cb55c34902fa4114a0fcb7f5cea742e8f5ec69786f12305cdec01457fb1fe4e2 -->
export CC_PACKAGE_ID=hyperledger-fabric-contract-java-demo_1:c67d435a60a6f863648acf7006f054a84f7d89a73f1272c83ee8d89a0544216d

# ��y??��?

## org1 ��y??��?:
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

<!-- peer lifecycle chaincode approveformyorg -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --channelID businesschannel --name hyperledger-fabric-contract-java-demo --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -->

<!-- peer lifecycle chaincode approveformyorg -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --channelID businesschannel --name card-contract --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 -->
peer lifecycle chaincode approveformyorg -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --channelID businesschannel --name ${CODE_NAME} --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1


#### ?�ʔ@���F
[025 02-18 05:37:12.44 UTC] [chaincodeCmd] ClientWait -> INFO txid [895c0d4b9eee30419e068072b816906f660c1f9ddb7400b63d6892a001470c38] committed with status (VALID) at peer0.org1.example.com:7051

## org2 ��y??��?:
<!-- export CORE_PEER_TLS_ENABLED=true -->
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051

<!-- peer lifecycle chaincode approveformyorg -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --channelID businesschannel --name hyperledger-fabric-contract-java-demo --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -->

peer lifecycle chaincode approveformyorg -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --channelID businesschannel --name ${CODE_NAME} --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1


### ??�ʓ���?���ۛߔ�y�����I??��?�F
<!-- peer lifecycle chaincode checkcommitreadiness --channelID businesschannel --name hyperledger-fabric-contract-java-demo --version 1.0 --sequence 1 --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --output json -->
<!-- peer lifecycle chaincode checkcommitreadiness --channelID businesschannel --name card-contract --version 1.0 --sequence 1 --output json -->
peer lifecycle chaincode checkcommitreadiness --channelID businesschannel --name ${CODE_NAME} --version 1.0 --sequence 1 --output json

#### ?�o?�ʔ@���F
{
	"approvals": {
		"Org1MSP": true,
		"Org2MSP": true
	}
}

## ��??��𓞒ʓ�:
<!-- peer lifecycle chaincode commit -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --channelID businesschannel --name hyperledger-fabric-contract-java-demo --version 1.0 --sequence 1 --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses peer0.org2.example.com:7051 --tlsRootCertFiles /etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -->

<!-- peer lifecycle chaincode commit -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --channelID businesschannel --name card-contract --version 1.0 --sequence 1 --peerAddresses peer0.org1.example.com:7051 --peerAddresses peer0.org2.example.com:9051  -->
peer lifecycle chaincode commit -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --channelID businesschannel --name ${CODE_NAME} --version 1.0 --sequence 1 --peerAddresses peer0.org1.example.com:7051 --peerAddresses peer0.org2.example.com:9051


#### ?�ʔ@���F
[029 02-18 05:50:47.62 UTC] [chaincodeCmd] ClientWait -> INFO txid [2c06365cd94ebcc95e4fc6e5a5334aafda35e874bf894ef604fd3a9fe18d86be] committed with status (VALID) at peer0.org2.example.com:7051
[02a 02-18 05:50:47.81 UTC] [chaincodeCmd] ClientWait -> INFO txid [2c06365cd94ebcc95e4fc6e5a5334aafda35e874bf894ef604fd3a9fe18d86be] committed with status (VALID) at peer0.org1.example.com:7051

### �p peer lifecycle chaincode querycommitted ���ߗ�????��?�ߒ��?�ʓ�:
<!-- peer lifecycle chaincode querycommitted --channelID businesschannel --name hyperledger-fabric-contract-java-demo --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -->
<!-- peer lifecycle chaincode querycommitted --channelID businesschannel --name card-contract -->
peer lifecycle chaincode querycommitted --channelID businesschannel --name ${CODE_NAME}

#### ?�ʔ@���F
Committed chaincode definition for chaincode 'hyperledger-fabric-contract-java-demo' on channel 'businesschannel':
Version: 1.0, Sequence: 1, Endorsement Plugin: escc, Validation Plugin: vscc, Approvals: [Org1MSP: true, Org2MSP: true]



# ?�p??

## ?�p createCard ����
<!-- peer chaincode invoke -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C businesschannel -n hyperledger-fabric-contract-java-demo --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses peer0.org2.example.com:7051 --tlsRootCertFiles /etc/hyperledger/fabric/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"createCat","Args":["cat-0" , "tom" ,  "3" , "?�F" , "��?�L"]}' -->

peer chaincode invoke -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com -C businesschannel -n ${CODE_NAME} --peerAddresses peer0.org1.example.com:7051 --peerAddresses peer0.org2.example.com:9051 -c '{"function":"createCat","Args":["cat-0" , "tom" ,  "3" , "?�F" , "��?�L"]}'





<!-- peer chaincode invoke -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com -C businesschannel -n card-contract --peerAddresses peer0.org1.example.com:7051 --peerAddresses peer0.org2.example.com:9051 -c '{"function":"updateCard","Args":["111" , "222" ,  "3333" , "444" , "5555"]}' -->
  

## ?�p getCard ����
<!-- peer chaincode query -C businesschannel -n hyperledger-fabric-contract-java-demo -c '{"Args":["queryCat" , "cat-0"]}' -->
peer chaincode query -C businesschannel -n card-contract -c '{"Args":["getCard" , "111"]}'




