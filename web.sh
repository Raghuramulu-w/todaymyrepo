#!?bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33"
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
    echo -e "$G you are root user $N"
fi
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
#VALIDATE $? "installation"
systemctl enable nginx
VALIDATE $? "enabling"
systemctl start  nginx
VALIDATE $? "starting"
rm -rf /usr/share/nginx/html/*
VALIDATE $? "removing"
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
cd /usr/share/nginx/html
unzip /tmp/web.zip 
VALIDATE $? "unzipping"
cp /home/centos/todaymyrepo/roboshop.conf /etc/nginx/default.d/roboshop.conf 
VALIDATE $? "copying "
systemctl restart nginx 
