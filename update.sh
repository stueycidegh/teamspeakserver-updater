#!/bin/bash

today=$(date "+%d%m%y")

rm backups/ts*.zip &> update.log

read -r -p "Do you wish to backup now? [y/N]: " backup

if [[ $backup =~ ^([yY][eE][sS]|[yY])$ ]]

then

        echo "Backing up - Please wait..."

        cp /etc/init.d/ts3 ts3-process.bak # Rename to ts3 and place in /etc/init.d/ upon restore

        zip -r9 backups/ts$today.zip ./* &>> update.log

        echo "Successfully backed up"

fi

read -r -p "Are you sure you want to update? [y/N]: " confirm

if [[ $confirm =~ ^([yY][eE][sS]|[yY])$ ]]

then

        echo "Updating - Please wait..."

        cd /opt/teamspeak3-server/ &>> update.log

        read -p "Enter Version: " version

        wget http://dl.4players.de/ts/releases/$version/teamspeak3-server_linux_amd64-$version.tar.bz2 &>> update.log

        tar -xjvf teamspeak3-server_linux_amd64-$version.tar.bz2 &>>  update.log

        cd ./teamspeak3-server_linux_amd64 &>> update.log

        rsync -av * ../ &>> update.log

        cd .. &>> /update.log

        rm teamspeak3-server_linux_amd64-$version.tar.bz2 &>> update.log

        rm -rf teamspeak3-server_linux_amd64 &>> /update.log

        rm ts3-process.bak

        /etc/init.d/ts3 restart &>> update.log

        chown -R teamspeak3-user:teamspeak3-user *

        echo "Teamspeak Updated!" >> update.log

        echo "Server successfully updated"

else

        exit

fi
