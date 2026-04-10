
# **Project 4**

## Description
* Goal:
  * The goal of this project is to build a container image from Apache and push it to Docker Hub, make a custom yml file template for AWS, run the website container on the instances, and configure HAProxy as the load balancer to direct traffic to the pool.



## Part 1: Web Service Container
* Website Content:
  * A cookie website that shows different cookie recipes.
  * [HTML and CSS files](https://github.com/WSU-kduncan/ceg3120-essentials-EthanWoe/tree/main/project3/web-content)
 
## Part 2: Web Service Container
* PAT Token creation
  * Go to the top right in Docker Hub and click on your profile icon, then settings
  * Click on personal access token.
  * Click generate new token.
  * Make the permissions read/write,e as we don't need execute or delete for this functionality.
  * Generate the token and copy it, as we won't be able to access it again after it is generated.

* GitHub integration with the PAT token
  *  Go to the repo that we want to do actions in.
  *  Go to the top bar on the repo and press on settings.
  *  Scroll down the side till you see **Secrets and Variables**
  *  Click on it, then click on generate a repository secret.
  *  Name the secret a valid name, then paste the token into the **bottom** text box.
  * The two secrets are the token and my username. This gives privacy, and we dont have to worry about leaking anything! Yay!
  ---
* Workflow Trigger
   * The workflow triggers when changes to the main branch are pushed.
* Workflow Steps
  * Checkout repository  
  * Login to DockerHub  
  * Build Docker image  
  * Push image to DockerHub  
* Values to Update
  * The image name would need to be updated as it would not be the same for user to user.
  * YOUR_USERNAME/cookiesite  

  * The secrets would also need to change to whatever they are named or the user would have to add their own token and username to GitHub.
   * DOCKER_USERNAME  
   * DOCKER_TOKEN

  [Link to actions file](https://github.com/WSU-kduncan/ceg3120-cicd-EthanWoe/blob/main/.github/workflows/docker.yml)

  
 ## Part 3: Web Service Container
* Website Content:
  * A cookie website that shows different cookie recipes.
  * [HTML and CSS files](https://github.com/WSU-kduncan/ceg3120-essentials-EthanWoe/tree/main/project3/web-content)
 
## Part 1: Web Service Container
* Website Content:
  * A cookie website that shows different cookie recipes.
  * [HTML and CSS files](https://github.com/WSU-kduncan/ceg3120-essentials-EthanWoe/tree/main/project3/web-content)
 

 


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
