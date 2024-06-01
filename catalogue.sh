#!/bin/bash

DATE=$(date +%F)
SCRIPT_NAME=$0
LOGFILE=/tmp/$0-$DATE.log
USERID=$(id -u)
USER=$(id roboshop)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE
VALIDATE $? "Setting up NPM Source"

yum install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing NodeJS"

if [ $USER -ne 0 ];
then
    useradd roboshop
    echo "Creating Roboshop User"
else
    echo "Roboshop User already exist"
    exit 1
fi

# #write a condition to check directory already exist or not
# mkdir /app &>>$LOGFILE

# curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

# VALIDATE $? "downloading catalogue artifact"

# cd /app &>>$LOGFILE

# VALIDATE $? "Moving into app directory"

# unzip /tmp/catalogue.zip &>>$LOGFILE

# VALIDATE $? "unzipping catalogue"

# npm install &>>$LOGFILE

# VALIDATE $? "Installing dependencies"

# # give full path of catalogue.service because we are inside /app
# cp /home/centos/roboshop-shellscript/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

# VALIDATE $? "copying catalogue.service"

# systemctl daemon-reload &>>$LOGFILE

# VALIDATE $? "daemon reload"

# systemctl enable catalogue &>>$LOGFILE

# VALIDATE $? "Enabling Catalogue"

# systemctl start catalogue &>>$LOGFILE

# VALIDATE $? "Starting Catalogue"

# cp /home/centos/roboshop-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

# VALIDATE $? "Copying mongo repo"

# yum install mongodb-org-shell -y &>>$LOGFILE

# VALIDATE $? "Installing mongo client"

# mongo --host mongodb.jiondevops.site </app/schema/catalogue.js &>>$LOGFILE

# VALIDATE $? "loading catalogue data into mongodb"