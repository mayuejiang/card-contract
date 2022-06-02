
# fabric?除????的docker容器

## 1、?看docker容器列表 
docker images 

## 2、?除????的容器

### 2.1 ?取IMAGE ID
docker images | awk '($1 ~ /dev-peer.*.card*/) {print $3}'

### 2.2 ?除??容器
docker rmi -f $(docker images | awk '($1 ~ /dev-peer.*.card*/) {print $3}')

