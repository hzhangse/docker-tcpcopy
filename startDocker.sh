#!/bin/bash
https://www.cnblogs.com/phennry/p/6382755.html?utm_source=itdadao&utm_medium=referral

sudo docker run  -dit --privileged=true  --name asistTcp --net shadownet --ip 172.19.0.36  rainbow/tcpcopy bash
/opt/tcpintercept/sbin/intercept  -i eth0 -F 'tcp and src port 8000' -d

sudo docker run  -d --privileged=true --name onlineTcp --net shadownet --ip 172.19.0.34 -e SERVER=java rainbow/tcpcopy /run.sh
python -m SimpleHTTPServer
/opt/tcpcopy/sbin/tcpcopy -x 172.19.0.34:8000-172.19.0.35:8000 -s 172.19.0.36 -c 192.168.2.254 -d
/opt/tcpcopy/sbin/tcpcopy -x 172.19.0.34:8000-172.19.0.35:8000 -s 172.19.0.36 -c 192.168.2.254 -n 2 -d

sudo docker run  -d   --privileged=true --name testTcp --net shadownet --ip 172.19.0.35 -e SERVER=java rainbow/tcpcopy /run.sh
route add -net 192.168.2.0 netmask 255.255.255.0 gw 172.19.0.36






