
# fabric?��????�Idocker�e��

## 1�A?��docker�e���\ 
docker images 

## 2�A?��????�I�e��

### 2.1 ?��IMAGE ID
docker images | awk '($1 ~ /dev-peer.*.card*/) {print $3}'

### 2.2 ?��??�e��
docker rmi -f $(docker images | awk '($1 ~ /dev-peer.*.card*/) {print $3}')

