#!/bin/sh
########SSH
echo $KEY >> /home/ssh/authorized_keys
LOCAL_IP=$(hostname -i)
SSH_IP_PORT=$LOCAL_IP:8022
sed -i "s/0.0.0.0/$SSH_IP_PORT/g" /home/ssh/sshd_config
echo "SSH server started at $(cat /home/ssh/sshd_config | grep ListenAddress)"
/home/ssh/sshd -f /home/ssh/sshd_config
#######HTTP TUNNEL
HTTP_TUNNEL_SSH_PORT=9022
echo Http tunnel server started at $HTTP_TUNNEL_SSH_PORT
/home/bin/hts -w -D2 -c 10240K -k 30 -S -F $LOCAL_IP:8022 $HTTP_TUNNEL_SSH_PORT
#/home/ssh/sshd -f /home/ssh/sshd_config -D -ddd -e

tail -f /dev/null
