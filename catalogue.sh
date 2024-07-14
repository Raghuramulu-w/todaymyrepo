#!?bin/bash
#!?bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
VALIDATE(){
    if [ $1 -ne 0 ]
    then 
      echo -e"$R $2 failed"
      exit 1
    else
      echo -e "$G $2 success"
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

#installation checking
for package in $@
do
 dnf list installed $package &>> $LOGFILE
 if [ $? -ne 0 ]
  then
       dnf install $package 
  else
  echo -e "$Y package is already installed .... skipping " 
  fi
done
#dnf module disable nodejs -y
#dnf module enable nodejs:18 -y
useradd roboshop
mkdir -p /app
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
cd /app 
unzip /tmp/catalogue.zip
npm install 
VALIDATE $? "npm installing"
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
mongo --host mongodb.daws76s.fun </app/schema/catalogue.js
