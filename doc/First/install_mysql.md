# mysql 
# ��Ayum��������
## 1.�R��centOS7����?������MariaDB,���v��?�s��?
rpm -qa | grep -i mariadb
rpm -e --nodeps mariadb-libs-5.5.64-1.el7.x86_64
??���{��mysql���ۉ�?��?
rpm -qa | grep mysql

## 2.��?MySQL??�����
wget https://repo.mysql.com//mysql80-community-release-el7-3.noarch.rpm

yum -y install mysql80-community-release-el7-3.noarch.rpm
   
#### 2022�N5��2���X�V�F����?�����\�����@��??�ٖ@�����C������Mysql�IGPG��?���C���v�d�V?��
   rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

## 3.��?����MySQL8.0�C�@�ʎ��v����MySQL5.7�I?���v�C��/etc/yum.repos.d/mysql-community.repo�z�u����

## 4.����MySQL����?
yum -y install mysql-community-server

## 5.??mysql��?
systemctl start mysqld.service

## 6.?��mysql��?��?��o?
cat /var/log/mysqld.log | grep password

2022-05-30T00:48:49.913851Z 6 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: O?9pt_SQ1IsN

## 
mysql -uroot -p


���F�L�\�����@��?��v�C��?��C����???��?�C�։�???�s�C����???��������
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyPassword.0001';


# MySQL��?�z�u�C��
## 1.�C�����n��?�i��z��?�㖧?�j
SHOW variables LIKE 'validate_password%';

# ����???������?LOW�C��??�x4�ʈȏ�
set global validate_password.policy=0;
set global validate_password.length=4;    #�d?MySQL�@����
ALTER USER 'root'@'localhost' IDENTIFIED BY 'your password';

mysql -uroot -p


### �Y?root��??�F ###
�d�uroot��??��(??skip-grant-tables)

UPDATE mysql.user SET authentication_string = '' WHERE user = 'root';