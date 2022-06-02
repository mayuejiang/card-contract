# mysql 
# 一、yum方式安装
## 1.由于centOS7中默?安装了MariaDB,需要先?行卸?
rpm -qa | grep -i mariadb
rpm -e --nodeps mariadb-libs-5.5.64-1.el7.x86_64
??下本机mysql是否卸?干?
rpm -qa | grep mysql

## 2.下?MySQL??并安装
wget https://repo.mysql.com//mysql80-community-release-el7-3.noarch.rpm

yum -y install mysql80-community-release-el7-3.noarch.rpm
   
#### 2022年5月2日更新：安装?程中可能遇到如下??无法安装，原因是Mysql的GPG升?了，需要重新?取
   rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

## 3.默?安装MySQL8.0，如果需要安装MySQL5.7的?需要修改/etc/yum.repos.d/mysql-community.repo配置文件

## 4.安装MySQL数据?
yum -y install mysql-community-server

## 5.??mysql服?
systemctl start mysqld.service

## 6.?看mysql默?密?并登?
cat /var/log/mysqld.log | grep password

2022-05-30T00:48:49.913851Z 6 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: O?9pt_SQ1IsN

## 
mysql -uroot -p


注：有可能遇到如下?情况，此?先修改密???密?，便可以???行修改密???策略操作
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyPassword.0001';


# MySQL相?配置修改
## 1.修改初始密?（若想改?弱密?）
SHOW variables LIKE 'validate_password%';

# 将密???策略改?LOW，密??度4位以上
set global validate_password.policy=0;
set global validate_password.length=4;    #重?MySQL后失效
ALTER USER 'root'@'localhost' IDENTIFIED BY 'your password';

mysql -uroot -p


### 忘?root密??： ###
重置root密??空(??skip-grant-tables)

UPDATE mysql.user SET authentication_string = '' WHERE user = 'root';