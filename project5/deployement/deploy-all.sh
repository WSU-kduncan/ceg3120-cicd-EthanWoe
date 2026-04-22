#!/bin/bash
set -euo pipefail

# Runs the existing container refresh script on each backend webserver.
WEB_HOSTS=(
  "ubuntu@192.168.1.10"
  "ubuntu@192.168.1.11"
  "ubuntu@192.168.1.12"
)
REMOTE_SCRIPT="/home/ubuntu/ceg3120-cicd-EthanWoe/project5/deployement/script.sh"

for host in "${WEB_HOSTS[@]}"; do
  echo "Deploying on ${host}"
  ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new "${host}" "bash ${REMOTE_SCRIPT}"
done

echo "All webservers updated"
