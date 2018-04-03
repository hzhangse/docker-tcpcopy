#!/bin/bash

IP=$(grep "\s${HOSTNAME}$" /etc/hosts | head -n 1 | awk '{print $1}')

if [ -n "$TestServer" ]; then
     /opt/tcpcopy/sbin/tcpcopy -x ${IP}:${CopyPort}-${TestServer}:${CopyPort} -s ${InterceptServer} -c 192.168.2.254 -d	
   exec  java -jar /data-acceptance.jar  
fi


#exec python -m SimpleHTTPServer

