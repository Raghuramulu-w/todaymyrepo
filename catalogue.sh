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
dnf module disable nodejs -y &>> $LOGFILE
dnf module enable nodejs:18 -y &>> $LOGFILE

#installation checking
for package in $@
do
 dnf list installed $package &>> $LOGFILE
 if [ $? -ne 0 ]
  then
       dnf install $package 
  else
  echo -e "$Y package is already installed .... skipping $N" 
  fi
done

useradd roboshop
mkdir -p /app
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
cd /app 
unzip /tmp/catalogue.zip
npm install 
VALIDATE $? "npm installing"
cp /home/centos/todaymyrepo/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "copying"
systemctl daemon-reload
VALIDATE $? "reloaddemon"
systemctl enable catalogue
VALIDATE $? "enableing "
systemctl start catalogue
VALIDATE $? "starting"
cp /home/centos/todaymyrepo/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongodb"
dnf install mongodb-org-shell -y
VALIDATE $? "mongodb installation "
mongo --host MONGDB_HOST </app/schema/catalogue.js
