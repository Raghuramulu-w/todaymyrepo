#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0 -$TIMESTAMP.log"
VALIDATE(){
    if [ $1 -ne 0 ]
    then 
    echo " $2 fail"
    else
    echo "$2 success"
    fi
}
CHECKING(){
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
}
echo "script executation started at $TIMESTAMP"
if [ $ID -ne 0 ]
 then
    echo -e "$R error you are not root user "
    exit 1
 else
    echo -e "$G you are root user so that you can proceed instalation $N"
fi
cp mongo.repo /etc/yum.repos.d/mongo.repo

#CHECKING()
VALIDATE $? "copying"
CHECKING()
VALIDATE $? "package success"