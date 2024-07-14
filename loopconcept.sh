#!/bin/bash
ID=$(id -u)
if [ $ID -ne 0 ]
then
    echo "error you are not root user"
    exit 1
  else
    echo "you are root user so you can proceed instalation"
fi
for package in $@
do 
 yum list installed $package
  if [ $? -ne 0 ]
   then 
     yum install $package
    echo "installation done "
    else 
      echo "installation already done so skipping"
  fi  
  done