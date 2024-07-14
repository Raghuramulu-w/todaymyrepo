#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo "$R  $2 fail $N"
    else
        echo "$G $2 success $N "
    fi
}
if [ $ID -ne 0 ]
 then 
    echo "$R you are not root user "
else
    echo "$G you are root user "
fi
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module enable redis:remi-6.2 -y
dnf install redis -y
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
VALIDATE $? "remote changes "
systemctl enable redis
VALIDATE $? "enabling "
systemctl start redis
VALIDATE $? " starting redis"

