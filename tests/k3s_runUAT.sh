#!/bin/bash

# set variables
hostname=`hostname -i`
port=$1

# wait for the app to start
sleep 5 

# ping the app
status_code=$(curl --write-out %{http_code} --output /dev/null --silent ${hostname}:${port})

if [ $status_code -eq 200 ];
then
	echo "PASS: ${hostname}:${port} is reachable"
else
	echo "FAIL: ${hostname}:${port} is unreachable"
    exit 1
fi
