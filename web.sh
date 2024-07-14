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
}
if [ $ID -ne 0 ]
then
    echo -e "$R you are not root user"
    exit 1
else
    echo -e "$G you are root user"
fi
#installation checking
for package $@
do
 yum list installed $package
 if [$? -ne 0 ]
 then
  yum install $package &>> $LOGFILE
  else
  echo "package is already installed .... skipping" &>> $LOGFILE
  fi
done
VALIDATE $? "installation"