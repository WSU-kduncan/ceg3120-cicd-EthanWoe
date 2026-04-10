
# **Project 4**

## Description
* Goal:
  * The goal of this project is to build a container image from Apache and push it to Docker Hub, make a custom yml file template for AWS, run the website container on the instances, and configure HAProxy as the load balancer to direct traffic to the pool. And have GitHub Actions validate and push changes and tag dockerhub and github.



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
* Generating `tag`s 
    * You can see the tags in the git reposotiry under releases called tags. You can also see it in action, and it properly labels the action with the right tag.
    * To generate a tag, do: ``` git tag -a v1.0.3 -m "test"```. This will set your branch in this version number
    * To push this version do ```git push origin v1.0.3```
* Semantic Versioning Container Images with GitHub Actions
    * The automation is configured to trigger specifically when a new **tag** is pushed to the repository. This ensures that every  release in git has a new image build for the container.
    * workflow steps
      * Checkout: Pulls the repository code into the runner.
      * Docker Login: Authenticates with DockerHub using stored secrets.
      * Get Metadata: Parses the Git tag to determine the image version.
      * Build and Push: Compiles the Dockerfile and pushes the resulting image to DockerHub with the semantic version tag.
    * Explanation/highlight of values that need to be updated if used in a different repository
      * Workflow Changes: Update the `image_name` variable in the YAML file to match your project.
      * Repository Changes: Ensure `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are added to the new repository's **Actions Secrets**.
    *  [Link to actions file](https://github.com/WSU-kduncan/ceg3120-cicd-EthanWoe/blob/main/.github/workflows/docker.yml)
* Testing & Validating
    * Check the actions tab in the repository. A successful run will show a green checkmark next to the "Build and Push" job. 
    * You can verify by pulling the image, then running the container.
    * [Link to your DockerHub repository](https://hub.docker.com/r/ethanwoe/cookiesite/tags)
 
## Part 4: Diagram



 

 


---
# Citations

* Gemini Prompts:
  ```
  What is this yml syntax error mean
  ```
* Lucid Chart:
  ```
  inserted yml file into the whiteboard to get ai generated diagram
  ```
* [HaProxy](https://discourse.haproxy.org/t/directory-for-haproxy-config-files/6967)
