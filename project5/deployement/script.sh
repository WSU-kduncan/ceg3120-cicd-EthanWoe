#!/bin/bash

IMAGE_NAME="ethanwoe/cookiesite"
CONTAINER_NAME="cookiesite"

echo "stopping container"
docker stop $CONTAINER_NAME || true

echo "removing container"
docker rm $CONTAINER_NAME || true

echo "stopping any container using port 80"
docker ps -q --filter "publish=80" | xargs -r docker stop

echo "removing any container using port 80"
docker ps -aq --filter "publish=80" | xargs -r docker rm

echo "pulling image"
docker pull $IMAGE_NAME:latest

echo "starting container"
docker run -d --name $CONTAINER_NAME -p 80:80 --restart always $IMAGE_NAME:latest

echo "done"
