#!/bin/bash

DATE=$(date +%F:%H:%M:%S)
SCRIPT_NAME=$0
LOGDIR=/tmp
LOGFILE=$LOGDIR/$0-$DATE.log
USERID=$(id -u)
USER=$(id roboshop)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: You should be the ROOT user to run this command $N"
    exit 1
fi

VALIDATE(){
    if [ $? -ne 0 ];
    then
        echo -e $2 ... $R FAILURE $N"
        exit 1
    else
        echo -e $2 ... $G SUCCESS $N"
    fi
}

SKIP(){
	echo -e "$1 Exist... $Y SKIPPING $N"
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
VALIDATE $? "Setting up NPM Source"

yum install nodejs -y &>> $LOGFILE
VALIDATE $? "Installing Node-js"

if [ $USER -ne 0 ];
then
    SKIP "Roboshop user"
else
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "Creating Roboshop user"
fi

if [ -d app ];
then
    SKIP "app"
else
    mkdir /app &>> $LOGFILE
    VALIDATE $? "Making app Directory"
fi

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
VALIDATE $? "Downloading catalogue artifact" 

cd /app &>> $LOGFILE
VALIDATE $? "Movinginto the app directory"

unzip /tmp/catalogue.zip &>> $LOGFILE
VALIDATE $? "Unzipping the dependencies"

npm install &>> $LOGFILE
VALIDATE $? "Installing the dependencies"

cp /home/centos/roboshop-shellscript/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE
VALIDATE $? "Copying catalogue.service"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "Daemon Reloading Catalogue"

systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "Enabling Catalogue"

systemctl start catalogue &>> $LOGFILE
VALIDATE $? "Starting Catalogue"

cp /home/centos/roboshop-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "Copying the mongo.repo"

yum install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "Installing mongodb-client"

mongo --host mongodb.vijaydeepak0812.online </app/schema/catalogue.js
VALIDATE $? "loading catalogue data into mongodb"