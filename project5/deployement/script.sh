#!/bin/bash
set -euo pipefail

IMAGE_NAME="ethanwoe/cookiesite"
CONTAINER_NAME="cookiesite"
REMOTE_SCRIPT="/home/ubuntu/ceg3120-cicd-EthanWoe/project5/deployement/script.sh"
SSH_KEY_PATH="${SSH_KEY_PATH:-$HOME/webserver.pem}"
WEB_HOSTS=(
	"ubuntu@192.168.1.10"
	"ubuntu@192.168.1.11"
	"ubuntu@192.168.1.12"
)

deploy_local() {
	echo "stopping container"
	docker stop "$CONTAINER_NAME" || true
	echo "removing container"
	docker rm "$CONTAINER_NAME" || true
	echo "pulling image"
	docker pull "$IMAGE_NAME:latest"
	echo "starting container"
	docker run -d --name "$CONTAINER_NAME" -p 80:80 --restart always "$IMAGE_NAME:latest"
	echo "local deploy done"
    exit
}

deploy_all() {
	if [[ ! -f "$SSH_KEY_PATH" ]]; then
		echo "SSH key not found at $SSH_KEY_PATH"
		exit 1
	fi

	for host in "${WEB_HOSTS[@]}"; do
		echo "Deploying on ${host}"
		ssh -T -i "$SSH_KEY_PATH" -o RequestTTY=no -o IdentitiesOnly=yes -o BatchMode=yes -o StrictHostKeyChecking=accept-new "$host" "bash $REMOTE_SCRIPT --local-only"
	done

	echo "all webservers updated"
}

if [[ "${1:-}" == "--local-only" ]]; then
	deploy_local
else
	deploy_all
fi
