#!/bin/bash
ID=$(id -u)
if [ $ID -ne 0 ]
then
    echo "error you are not root user"
    exit 1
  else
    echo "you are root user so you can proceed instalation"
fi
for package $@
do 
 yum list installed $package
  if [ $? -ne 0 ]
   then 
    echo "installation failed "
    else 
      echo "installation success"
  fi  
  done