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
    echo -e "$G you are root user"
fi
#installation checking
for package in $@
 dnf list installed $package
 do
 if [ $? -ne 0 ]
  then
       dnf install $package 
  else
  echo "package is already installed .... skipping" 
  fi
done
VALIDATE $? "installation"
systemctl enable nginx
VALIDATE $? "enabling"
systemctl start  nginx
VALIDATE $? "starting"
