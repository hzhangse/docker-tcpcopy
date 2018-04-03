#!/bin/bash

if [ -n "$InterceptServer" ]; then
   route add -net 192.168.2.0 netmask 255.255.255.0 gw ${InterceptServer}
   exec  java -jar /data-acceptance.jar 
  
fi


#exec python -m SimpleHTTPServer

