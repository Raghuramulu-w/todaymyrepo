#!/bin/bash
ID=$(id -u)
R="\[31m"
G="\[32m"
Y="\[33m"
N="\[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0 -$TIMESTAMP.log"
echo "script executation started at $TIMESTAMP"
if [ $ID -ne 0 ]
 then
    echo -e "$R error you are not root user "
    exit 1
 else
    echo -e "$G you are root user so that you can proceed instalation $N"
fi
#cp mongo.repo /etc/yum.repos.d/mongo.repo
#VALIDATE()
 for package in $@
    do
    yum list installed $package
      if [ $? -ne 0 ]
    then 
        yum install $package &>> $LOGFILE
    else
        echo "package is already installed skipping"
    fi
 done