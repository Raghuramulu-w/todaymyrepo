#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGDB_HOST=mongodb.daws76s.fun
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
VALIDATE(){
    if [ $1 -ne 0 ]
    then 
      echo -e"$R $2 failed $N"
      exit 1
    else
      echo -e "$G $2 success $N"
    fi
}
if [ $ID -ne 0 ]
then
    echo -e "$R you are not root user"
    exit 1
else
    echo -e "$G you are root user $N "
fi
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
VALIDATE $? "installation nodejs "
useradd roboshop
mkdir /app
curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
cd /app 
unzip /tmp/cart.zip
npm install 
VALIDATE $? "npm instalation"
cp /home/centos/todaymyrepo/cart.service /etc/systemd/system/cart.service
#VALIDATE $? "npm instalation"
systemctl daemon-reload
systemctl enable cart 
systemctl start cart