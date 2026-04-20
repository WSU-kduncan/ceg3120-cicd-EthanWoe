#!/bin/bash

IMAGE_NAME="ethanwoe/cookiesite"
CONTAINER_NAME="cookiesite"

echo "stopping container"
docker stop $CONTAINER_NAME || true
echo "removing container"
docker rm $CONTAINER_NAME || true
echo "pulling image"
docker pull $IMAGE_NAME:latest
echo "starting container"
docker run -d --name $CONTAINER_NAME -p 80:80 --restart always $IMAGE_NAME:latest
echo "done"
