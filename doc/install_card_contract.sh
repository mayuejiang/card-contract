# bring down the latest network
cd test-network
./network.sh down

# bring up the testwork and create mychannel with couchDB
./network.sh up createChannel -s couchdb

export PATH=${PWD}/../bin:$PATH

export FABRIC_CFG_PATH=$PWD/../config/

# check peer version
peer version

# package the chaincode as cardcontract.tar.gz
peer lifecycle chaincode package cardcontract.tar.gz --path ../cardcontract/ --lang java --label cardcontract_1.0


# use org1' admin certificate
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

# install chaincode on org1's peer
peer lifecycle chaincode install cardcontract.tar.gz


# use org2' admin certificate
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

# install chaincode on org2's peer
peer lifecycle chaincode install cardcontract.tar.gz

# query chaincodes installed on the channel
peer lifecycle chaincode queryinstalled

# set package_ID enviroment variables for subsequent use
## TODO:replace package id
export CC_PACKAGE_ID=cardcontract_1.0:82535406a659be323c6ffd90a4f51af323d24858201aa4d8aa98eaed1fe82d8f

# Approve for org2
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name cardcontract --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem


# use org1' admin certificate
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:7051

# Approve for org1
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name cardcontract --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem


# check if the chaincode is aprroved
peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name cardcontract --version 1.0 --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --output json

# commit the chaincode
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name cardcontract --version 1.0 --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

# check if the chaincode is committed
peer lifecycle chaincode querycommitted --channelID mychannel --name cardcontract --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# verify index was deployed
docker logs peer0.org1.example.com 2>&1 | grep "CouchDB index"






# init the ledger to create some tasks
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n cardcontract --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"createCard","Args":["Card-001", "CARD001","https://www.baidu.com/s?wd=%E7%99%BE%E5%BA%A6%E7%83%AD%E6%90%9C&sa=ire_dl_gh_logo_texing&rsv_dl=igh_logo_pcs","privatekey000000001","ma yuejiang"]}'
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n cardcontract --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"createCard","Args":["Card-002", "CARD002","imageUrl002","privatekey000000002","ma yuejiang"]}'
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n cardcontract --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"createCard","Args":["Card-003", "CARD003","imageUrl003","privatekey000000003","ma yuejiang"]}'
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n cardcontract --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"createCard","Args":["Card-004", "CARD004","imageUrl004","privatekey000000004","ma yuejiang"]}'
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n cardcontract --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"createCard","Args":["Card-005", "CARD005","imageUrl005","privatekey000000005","ma yuejiang"]}'
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n cardcontract --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"createCard","Args":["Card-006", "CARD006","imageUrl006","privatekey000000006","ma yuejiang"]}'

# query all cards in mychannel
#peer chaincode query -C mychannel -n cardcontract -c '{"Args":["getAllCards"]}'

# query cards name by CARD001
peer chaincode query -C mychannel -n cardcontract -c '{"Args":["queryCardByName", "CARD001"]}'

# query cards owned by ma yuejiang
peer chaincode query -C mychannel -n cardcontract -c '{"Args":["queryCardByOwner", "ma yuejiang"]}'

# query card's info
peer chaincode query -C mychannel -n cardcontract -c '{"Args":["getCard", "Card-001"]}'

# invoke to changeCardOwner card to yan xiangang
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n cardcontract --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"changeCardOwner","Args":["Card-001", "yan xiangang"]}'

# re-query task1's info to check if task's owner has changed
peer chaincode query -C mychannel -n cardcontract -c '{"Args":["getCard", "Card-001"]}'

# re-query tasks owned by yan xiangang
peer chaincode query -C mychannel -n cardcontract -c '{"Args":["queryCardByOwner", "yan xiangang"]}'
# re-query tasks privateKey by privatekey000000001
peer chaincode query -C mychannel -n cardcontract -c '{"Args":["queryCardByPrivateKey", "privatekey000000001"]}'

# querry the history of Card-001
#peer chaincode query -C mychannel -n basic -c '{"Args":["GetCardHistory", "Card-001"]}' 
  
# use the bookmark the last querry returned this time  (return 1-3)
peer chaincode query -C mychannel -n basic -c '{"Args":["queryCardPageByOwner", "ma yuejiang","3",""]}'
# TODO: replace bookmark (return 4-6)
peer chaincode query -C mychannel -n basic -c '{"Args":["queryCardPageByOwner", "ma yuejiang","3","g1AAAABHeJzLYWBgYMpgSmHgKy5JLCrJTq2MT8lPzkzJBYqzliQWZ5uDJDlgkjlAYUaQHA9ILr4gv7gktcgsKwsAt5IUbA"]}'

# delete card Card-005
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n cardcontract --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"deleteCard","Args":["Card-005"]}'

# query cards owned by ma yuejiang
peer chaincode query -C mychannel -n cardcontract -c '{"Args":["queryCardByOwner", "ma yuejiang"]}' 


# bring down the network
# ./network.sh down