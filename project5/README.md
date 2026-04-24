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

## 2 Listen
1. Configuring a `webhook` Listener on EC2 Instance
    - How to install [adnanh's `webhook`](https://github.com/adnanh/webhook) to the EC2 instance
        - ```sudo apt install webhook``` 
    - How to verify successful installation
        - ```sudo systemctl status webhook```
    - Summary of the `webhook` definition file
        - The webhook definition file has the hook id which is used in the link to trigger, the path to the executable script, and the rules of triggering. 
    - How to verify definition file was loaded by `webhook`
        - ```webhook -hooks hooks.json -verbose```
    - How to verify `webhook` is receiving payloads that trigger it
      - how to monitor logs from running `webhook`
          - ```journalctl -u webhook.service -f```
      - what to look for in `docker` process views
          - Status of the webhook triggering the path to the executable file running, and it says successful. 
    - [Hookfile](https://github.com/WSU-kduncan/ceg3120-cicd-EthanWoe/blob/main/project5/deployement/hooks.json)
2. Configure a `webhook` Service on EC2 Instance 
    - Summary of `webhook` service file contents
        -  This file defines a systemd service that runs the webhook as  Ubuntu in the background on the EC2 instance using hooks.json on port 9000. It ensures the service starts on boot and automatically restarts if it stops.
    - How to `enable` and `start` the `webhook` service
    - ```
      sudo systemctl daemon-reload
      sudo systemctl enable webhook
      sudo systemctl start webhook
      ```
    - How to verify `webhook` service is capturing payloads and triggering bash script
      - ```journalctl -u webhook.service -f``` will tell you if the command is executed 
    - [Service file](https://github.com/WSU-kduncan/ceg3120-cicd-EthanWoe/blob/main/project5/deployement/webhook.service)

# 3. Configuring a Payload Sender

* Justification for selecting GitHub or DockerHub as the payload sender
    - GitHub is used because it provides built-in webhook support that can automatically send payloads on repository events such as pushes, tags, or releases.

* How to enable your selection to send payloads to the EC2 `webhook` listener
    - Go to your repository, go to Settings, then Webhooks.
    - Click Add webhook and give it a name.
    - Enter the webhook URL ```http://123.123.123.123:9000/hooks/redeploy-app```
    - Add your secret token/message in the secret field.
    - Save the webhook configuration.

* Explain what triggers will send a payload to the EC2 `webhook` listener
    - A payload is sent when pushing commits or tags to the repository.

* How to verify a successful payload delivery
    - After pushing changes, GitHub will show the delivery status as successful in the webhook settings.
    - You can also confirm success by checking your deployed website to see if updates were applied.

* How to validate that your webhook *only triggers* when requests are coming from appropriate sources (GitHub or DockerHub)
    - Validation is done using the secret passkey in the `hooks.json` file, which ensures only authorized requests trigger the webhook.

## 4. Documentaiton

<img width="1028" height="490" alt="image" src="https://github.com/user-attachments/assets/b797a6b0-603f-49b4-857a-cb4ef7167493" />

The webhook.service, hooks.json, and bash script work together to automate deployment on the EC2 instance as the ubuntu user. The service runs the webhook listener in the background, the hooks.json file defines what endpoint triggers the deployment, and the bash script contains the actual commands that execute when a webhook payload is received.


# Citations

* [Lucid Charts](https://lucid.app/documents#/documents?folder_id=home)
* [adnanh/webhook](https://github.com/adnanh/webhook)
* [github](https://docs.github.com/en/webhooks/using-webhooks/creating-webhooks)
