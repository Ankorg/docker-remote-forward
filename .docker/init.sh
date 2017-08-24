#!/bin/sh

if [[ -z "$KEY" ]]; then echo "key is mandatory"; exit 1 ; fi;

USER_ID=$(id -u)
if [ x"$USER_ID" != x"0" -a x"$USER_ID" != x"1001" ]; then
	NSS_WRAPPER_PASSWD=/tmp/passwd
	NSS_WRAPPER_GROUP=/etc/group
	cat /etc/passwd | sed -e 's/^nonrootuser:/oldnonrootuser:/' > $NSS_WRAPPER_PASSWD
    	echo nonrootuser:x:$USER_ID:0:,,,:/home/nonrootuser:/bin/bash >> $NSS_WRAPPER_PASSWD
    	export NSS_WRAPPER_PASSWD
    	export NSS_WRAPPER_GROUP
    	LD_PRELOAD=/usr/local/lib/libnss_wrapper.so
    	export LD_PRELOAD
	echo "Done exporting User with Id - $(id)"
fi

exec tini -- "$@"
