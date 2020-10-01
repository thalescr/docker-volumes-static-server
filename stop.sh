#!/bin/bash

set -e

# Check if user is root
if (($EUID != 0)); then
    echo "Please run this script as root."
    exit
fi

docker stop static-server
docker rm static-server
docker rmi static-server

echo "Successfully stopped and deleted container static-server"