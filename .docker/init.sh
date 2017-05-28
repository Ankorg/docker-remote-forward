#!/bin/sh

if [[ -z "$KEY" ]]; then echo "key is mandatory"; exit 1 ; fi;

echo $KEY >> /home/ssh/authorized_keys
#service ssh start
echo $PASSWD | sudo -u $USER --stdin
/home/ssh/sshd -f /home/ssh/sshd_config

tail -f /dev/null
