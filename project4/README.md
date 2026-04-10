
# **Project 3**

## Description
* Goal:
  * The goal of this project is to build a container image from Apache and push it to Docker Hub, make a custom yml file template for AWS, run the website container on the instances, and configure HAProxy as the load balancer to direct traffic to the pool.
* Usage and Creation of Cloud Templates:
  * Login to AWS
  * Create Stack
  * Upload Template
  * Configure stack options by giving it the stack name and choosing the vockey key type
  * Create the stack
  * This will then create, and you can see the progress in the events page if there are any errors.
* Resources Built:
  * VPC with CIDR block 192.168.0.0/23  
  * Public subnet  for the proxy instance  
  * Private subnet for backend instances  
  * Internet Gateway for public internet access  
  * NAT Gateway with Elastic IP for private instances' outbound traffic  
  * Route tables for public and private subnets  
  * Security Group for proxy instance  
  * Security Group for backend instances 
  * Proxy EC2 instance with public IP running HAProxy  
  * Three backend EC2 instances running Docker containers of the website  
  * Containers run in detached mode and restart automatically  
  * Load-balanced architecture directing traffic from proxy to backend pool  
* Diagram
  <img width="930" height="769" alt="image" src="https://github.com/user-attachments/assets/ea4e2f1e-6464-42f4-b4a1-af72dd6152b3" />


## Web Service Container
* Website Content:
  * A cookie website that shows different cookie recipes.
  * [HTML and CSS files](https://github.com/WSU-kduncan/ceg3120-essentials-EthanWoe/tree/main/project3/web-content)

* Building and pushing a container image to Docker Hub
  * Make a Dockerfile that downloads Apache and copies the files into Apache's root so Apache sees the documents without us having to do anything.
  * Build the image ``` docker build -t ethanwoe/cookiesite .```
  * Test on localhost to see if it works ```docker run -p 8080:80 ethanwoe/cookiesite```
  * If the previous are successful, login to Docker Hub using ```docker login```
  * After successfully logging in do ```docker push``` to upload it to the repository.
  * [DockerHub Link](https://hub.docker.com/repository/docker/ethanwoe/cookiesite/general)
  
## Connection to instances within the VPC
* Purpose if host/config files
 * The purpose is that these files act as a naming convention/DNS for your machine and allows you to map ips to names.
 * An example of this would instead of doing ```ping 192.123.123.123``` we could do ```ping machine1``` and it would route to the ip adress.
*  Required setup:
 *  All instances have the same public key
 *  Secuirty groups need to have traffic from the proxy
*  Once the config files is setup you can just type ```ssh machine1```

## Setting up HAProxy load balancers
* What is the HAProxy config file:
 * The file will tell the servers how to respond to traffic and in this case we will use round robin so that each request will go to the next. For example user 1 will go to server 1 user 2 to server 2 user 3 to server 3 and user 4 to server 1.
* Explaination of additions of config file
 * ```frontend woessner-frontend```  binds to port 80 and tells the traffic to send to the backend
 * ```backend woessner-pool``` Defines where the traffic goes again for this case is round robin.
 * ```listen stats``` allows you to see the statstics and distribution of service is working properly.
*  How to test the proxy file works before restarting ```sudo haproxy -c -f /etc/haproxy/haproxy.cfg```
*  Controls for HAProxy
 *  Start: For intial setup ```sudo systemctl start haproxy```
 *  Stop: Want to bring down for changes or other reasons: ```sudo systemctl stop haproxy```
 *  Reload: Want to apply changes ```sudo systemctl reload haproxy```
 *  Restart: Service is bugged or something weird is happening so attempt to restart ```sudo systemctl restart haproxy```
 *  [HAProxy config file](https://github.com/WSU-kduncan/ceg3120-essentials-EthanWoe/blob/main/project3/haproxy.cfg)

## Load Balancer Testing
* [Link to load balancer public IP](http://54.227.172.250/)
* Showing that hosts and Round Robin are being used and the algorithm is working

* These images show how my service is working. As you can see, if we look at the pool its evenly dividing the number of users in the round robin way. In image one, it shows 34,34 and 33 connections, then in image two after refresing my page 5 times it shows 36,35,35 coneections. Profing that the load balancer and config file is working properly.
<img width="1897" height="599" alt="image" src="https://github.com/user-attachments/assets/4fb7205c-0795-4cb7-ae13-70aa9ae47825" />
<img width="1906" height="737" alt="image" src="https://github.com/user-attachments/assets/2d3ad41e-298e-4fbd-a4bb-acf45fd7348f" />

---
# Citations

* Gemini Prompts:
  ```
  Create a cookie website with two HTML files and a CSS file
  ```
  ```
  Am i missing anything from this yml file from this assignment?
  ```
  ```
  in ha proxy i cant connect to the stats website
  ```
* Lucid Chart:
  ```
  inserted yml file into the whiteboard to get ai generated diagram
  ```
* [HaProxy](https://discourse.haproxy.org/t/directory-for-haproxy-config-files/6967)
