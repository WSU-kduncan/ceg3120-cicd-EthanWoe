# project 5

## Explanation of EC2 setup/Docker setup/bash script
1. ### EC2 Instance Details
    - **AMI information**
       - Amazon AMI
       - Ubuntu
       - us-east-1
    - **Instance type**
       - Proxy: This is a t2.medium and will act as the point of entrance for traffic.
        - Instance 1: t.2 medium 2vcpus and 4gig ram
        - Webserver2,3: t.2 micros, which is just the backend for Docker if the main instance gets overworked.
    - **Recommended volume size**
      - 20 GIGS: Just enough storage, as we are not actually storing information on the instance besides the website and Docker images.
    - **Security Group configuration**

       <img width="1619" height="304" alt="image" src="https://github.com/user-attachments/assets/57eb1ed3-4e94-4e7e-b756-dd23c322c4fe" />

    - **Security Group configuration justification / explanation**
      - 22: Allows for access into the instance through private IP
      - 80: All can connect to the instance through web traffic
      - 8080: so I can see the stats of the website- 
2. ### Docker Setup on OS on the EC2 instance
    - How to install Docker for OS on the EC2 instance
        - I'm installing Docker through the .yml file. They way to install docker through this is to make it run a set of commands on creation. Below is an exmaple
         ```
         UserData:
        Fn::Base64:
          !Sub |
            #!/bin/bash -xe
            apt-get update
            apt-get install -y docker.io
            systemctl enable docker
            systemctl start docker
            hostnamectl set-hostname web1
            docker run -d -p 80:80 --restart always ethanwoe/cookiesite
         ```
       -  Meaning the command for Docker specifically is ```apt-get install -y docker.io``` which installs it and replies to yes for a prompt.
        
    - Additional dependencies based on OS on the EC2 instance
        - Apache and HA proxies are also needed to set up the web server and the routing of connections.
    - How to confirm Docker is installed and that OS on the EC2 instance can successfully run containers
        - You can try to run a container or just do ```systemctl status docker``` and look for running/active

3. ### Testing on EC2 Instance
    - How to pull a container image from DockerHub repository
        - ```Docker pull ethanwoe/cookiesite```
    - How to run a container from an image
        - ```docker run -d --name cookiesite -p 80:80```
        - -It is used on your terminal, so when your terminal stops, the Docker process stops. Used for testing.
        - -d is running detached, so that means you can still visit the website, and the container will remain running even if you close out of the instance. Used for prodcution.
 - How to verify that the container is successfully serving the web application
     - Go to the public IP address of the EC2 instance and see if the web page is displaying properly.
   
4. ###Scripting Container Application Refresh
    - The bash script is made to stop the container, remove it, pull the new image, then start the container of the new image.
    - How to test / verify that the script successfully performs its taskings
        - Push a tag for a new version, then run the script. When the script is run, go to dockerhub and ook at the versioning on dockerhub
    - [**LINK to bash script**](https://github.com/WSU-kduncan/ceg3120-cicd-EthanWoe/blob/main/project5/deployement/script.sh)

## Webhook Troubleshooting and Fix

If changes to `index.html` are not showing up on all 3 webservers, there are two common causes:

1. The webhook was only redeploying one machine.
2. The container image was not rebuilt/pushed after editing `index.html`.

This repo now includes:

- `project5/deployement/deploy-all.sh`: fan-out deploy script for `web1`, `web2`, and `web3`.
- `project5/deployement/hooks.json`: fixed command path and both hook IDs (`redeploy-app` and `redeploy-webhook`) so either endpoint works.

### Required setup on proxy/webhook host

1. Ensure `deploy-all.sh` is executable:
    - `chmod +x /home/ubuntu/ceg3120-cicd-EthanWoe/project5/deployement/deploy-all.sh`
2. Ensure passwordless SSH from proxy to all three webservers as user `ubuntu`.
3. Restart webhook service:
    - `sudo systemctl daemon-reload`
    - `sudo systemctl restart webhook`
    - `sudo systemctl status webhook`

### Important

Editing `index.html` in git does not update running containers by itself. You must build and push a new Docker image first, then webhook-triggered redeploy can pull that new image on all servers.
