#!/bin/bash

DATE=$(date +%F:%H:%M:%S)
SCRIPT_NAME=$0
LOGDIR=/tmp
LOGFILE=$LOGDIR/$0-$DATE.log
USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ];
then
    echo -e "$R Errror:: You should be the ROOT user to run this command $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e $2 ... $R FAILURE $N"
        exit 1
    else
        echo -e $2 ... $G SUCCESS $N"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "Copying mongo.repo file in to yum.repos.d/mongo.repo"

yum install mongodb-org -y &>> $LOGFILE
VALIDATE $? "Installing Mongodb"

systemctl enable mongod &>> $LOGFILE
VALIDATE $? "Enabling mongodb"

systemctl start mongod &>> $LOGFILE
VALIDATE $? "Starting mongodb"

sed -i 's/127.0.0.0/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "Replacing 127.0.0.0 to 0.0.0.0 in mongod.conf"

systemctl restart mongod &>> $LOGFILE
VALIDATE $? "Restarting mongodb"