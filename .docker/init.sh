#!/bin/bash

if [[ -z $USER || -z $PASSWD ]]; then echo "username and password mandatory"; exit -1 ; fi;

adduser --quiet --disabled-password --shell /bin/bash --home /home/$USER --gecos "User" $USER
echo "$USER:$PASSWD" | chpasswd

service ssh start
ping localhost
