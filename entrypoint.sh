#!/bin/bash
service ssh start

echo 
if [ "$mode" = "intercept" ];then
   /opt/tcpintercept/sbin/intercept  -i eth0 -F "tcp and src port ${CopyPort}" -d ;
fi


exec "$@"
