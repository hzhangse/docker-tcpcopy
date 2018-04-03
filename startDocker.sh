#!/bin/bash
https://www.cnblogs.com/phennry/p/6382755.html?utm_source=itdadao&utm_medium=referral




sudo docker run  -dit --privileged=true  --name asistTcp --net shadownet --ip 172.19.0.36 -e mode=intercept -e CopyPort=8000 rainbow/tcpcopy bash

sudo docker run  -d   --privileged=true --name testTcp --net shadownet --ip 172.19.0.35 -e InterceptServer=172.19.0.36 rainbow/tcpcopy /runTestServer.sh

sudo docker run  -d --privileged=true --name onlineTcp --net shadownet --ip 172.19.0.34 -e CopyPort=8000 -e TestServer=172.19.0.35 -e InterceptServer=172.19.0.36 rainbow/tcpcopy /runOnlineServer.sh






