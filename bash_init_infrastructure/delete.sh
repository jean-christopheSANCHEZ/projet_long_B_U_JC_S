#!/bin/bash

docker stop -f $(docker ps -a -q)
docker rm -f $(docker ps -a -q)
docker network prune --force


