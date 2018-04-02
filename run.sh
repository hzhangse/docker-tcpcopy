#!/bin/bash


if [ -n "$SERVER" ]; then
   exec  java -jar /data-acceptance.jar 
fi


#exec python -m SimpleHTTPServer

