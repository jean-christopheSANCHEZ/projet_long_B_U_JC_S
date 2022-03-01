#!/bin/bash

docker stop -f $(docker ps -a -q)
docker rm -f $(docker ps -a -q)
docker network prune --force

./container.sh create_network r1 192.168.1.0/24
./container.sh create Alpine alpine r1 192.168.1.2 1
./container.sh create Alpine2 alpine r1 192.168.1.3 1
./container.sh create meta kalilinux r1 192.168.1.4 1
