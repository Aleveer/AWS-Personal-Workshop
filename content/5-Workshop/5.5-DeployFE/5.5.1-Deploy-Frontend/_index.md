---
title : "Deploy Frontend with Amplify"
weight : 1
chapter : false
pre : " <b> 5.5.1 </b> "
---
#### Prepare Github Repository

We will prepare a Github Repository. This Project has a Monorepo structure, containing a frontend folder and a backend folder. Here, we will deploy the frontend folder to Amplify.

![github-repo](/images/5-Workshop/5.5-DeployFE/5.5.1-Deploy-FE-Amplify/github-repo.png)

#### Start deploying with Amazon Amplify

In the AWS Console, access AWS Amplify and select Deploy an app.
![amplify-deploy](/images/5-Workshop/5.5-DeployFE/5.5.1-Deploy-FE-Amplify/amplify-deploy.png)

Continue by selecting your source code management platform; here I am using Github so I will select Github, then click Next.
![amplify-deploy1](/images/5-Workshop/5.5-DeployFE/5.5.1-Deploy-FE-Amplify/amplify-deploy1.png)

Amplify will show a new window, requesting GitHub authorization to authenticate for AWS Amplify.
![amplify-deploy2](/images/5-Workshop/5.5-DeployFE/5.5.1-Deploy-FE-Amplify/amplify-deploy2.png)

Continue to select the organizations containing the repository you need to deploy.
![amplify-deploy3](/images/5-Workshop/5.5-DeployFE/5.5.1-Deploy-FE-Amplify/amplify-deploy3.png)

Here, I only install for a specific repository, so I will choose “Only select repositories” and proceed to select the repo I need to deploy, then click “Install & Authorize”.
![amplify-deploy4](/images/5-Workshop/5.5-DeployFE/5.5.1-Deploy-FE-Amplify/amplify-deploy4.png)

At the screen below, you will select your repository (1) and select the branch (2). Depending on your folder structure, if your repository root folder is the folder containing the main source code to deploy, you will not need to check “My app is monorepo”. However, for my repository, the main source code to deploy is located in the frontend folder within the root directory, so I will check (3) and enter the frontend folder (4) to help Amplify identify the directory to focus on. Then click Next.
![amplify-deploy5](/images/5-Workshop/5.5-DeployFE/5.5.1-Deploy-FE-Amplify/amplify-deploy5.png)

Most of this part Amplify will automatically select for you. Proceed to enter the App name and you can review before clicking Next.
![amplify-deploy6](/images/5-Workshop/5.5-DeployFE/5.5.1-Deploy-FE-Amplify/amplify-deploy6.png)

You can click on Advanced Settings to view and tweak your Frontend build environment to suit the project. You just need to review and click Next.
![amplify-deploy7](/images/5-Workshop/5.5-DeployFE/5.5.1-Deploy-FE-Amplify/amplify-deploy7.png)

Review the important information and click Save and deploy.
![amplify-deploy8](/images/5-Workshop/5.5-DeployFE/5.5.1-Deploy-FE-Amplify/amplify-deploy8.png)

Wait a few minutes for Amplify to proceed with the deployment.
![amplify-deploy9](/images/5-Workshop/5.5-DeployFE/5.5.1-Deploy-FE-Amplify/amplify-deploy9.png)

After successful Deployment, Amplify will provide us with a random Domain; depending on needs, we will use this Domain or can add a Custom Domain as desired.
![amplify-deploy10](/images/5-Workshop/5.5-DeployFE/5.5.1-Deploy-FE-Amplify/amplify-deploy10.png)

We will proceed to copy that Domain and paste it into the browser to view the result.
![amplify-deploy11](/images/5-Workshop/5.5-DeployFE/5.5.1-Deploy-FE-Amplify/amplify-deploy11.png)

Thus, you have successfully deployed the Frontend to Amazon Amplify and can access it using the domain provided by Amplify. From now on, every time you update code on GitHub (frontend branch), Amplify will automatically rebuild and redeploy after a few minutes.

So the next step is: connecting the Frontend with the Backend running on ECS via ALB. Currently, the ALB returns an HTTP endpoint, while Amplify serves the Frontend via HTTPS. This causes a mixed content error and the browser will block the request.

In the next section, we will configure HTTPS for the ALB so that the Frontend and Backend communicate securely and correctly.
