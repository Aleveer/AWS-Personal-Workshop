---
title : "Configure to connect Frontend and Backend"
weight : 2
chapter : false
pre : " <b> 5.5.2 </b> "
---
#### Configure ALB to accept traffic from HTTPS.
Access EC2, select Load Balancer. Select the Backend's ALB.
![alb](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/alb.png)

Select Add listener to configure ALB to listen on HTTPS 443.
![alb2](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/alb2.png)

Select HTTPS and enter Port as 443.
![alb3](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/alb3.png)

Check Forward to target groups, select your Backend group.
![alb4](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/alb4.png)

In the Certificate Source section, select From ACM and select the Certificate you created earlier. And click Add listener.
![alb5](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/alb5.png)

Next is to configure the ALB's Security Group to allow traffic from HTTPS 443.
Access EC2 Security Groups. Select the ALB's Security Group.
![alb6](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/alb6.png)

Select Edit inbound rules.
![alb7](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/alb7.png)

Add HTTPS. Then click Save rules.
![alb8](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/alb8.png)

We have set up HTTPS for the domain and configured the ALB to accept HTTPS traffic (including from Amplify) to forward to ECS.


#### Configure Rewrites and redirects for Amplify
The next step, we go back to Amplify to configure the Frontend so that when sending API requests, the Frontend application will call the Backend via the ALB's HTTPS endpoint: https://api.webchat.mom.

We will go back to Amplify, select Hosting -> Rewrites and redirects.
![amplify-rewrite](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/amplify-rewrite.png)

These are the initial Rewrites and redirects.
![amplify-rewrite1](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/amplify-rewrite1.png)

In the current Rewrites and redirects section, if you call any path, it will return an index.html page.
![amplify-rewrite2](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/amplify-rewrite2.png)

We can see that when the Frontend calls the path /api/auth/login, Amplify applies the rule in the Rewrites and Redirects section and rewrites that request to the index.html file. Therefore, the response returned is the index.html page, as illustrated below.
![amplify-rewrite3](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/amplify-rewrite3.png)

We will return to the Rewrites and Redirects section of Amplify to configure it so that API requests are forwarded to the ALB's domain, instead of being rewritten to the index.html page as currently.

In Rewrites and redirects, we select Manage redirects.
![amplify-rewrite4](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/amplify-rewrite4.png)

We will delete all the old lines and add new lines as shown in the image below. Then click Save.
![amplify-rewrite5](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/amplify-rewrite5.png)

According to the image below, the meaning of each rule is as follows:

Line 1: When Frontend sends a request to the path /api/*, Amplify will rewrite that request to https://api.webchat.mom/api/\*.

Line 2: When Frontend accesses any other path (/*), Amplify will return the root file / (i.e., index.html) of the application.”
![amplify-rewrite6](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/amplify-rewrite6.png)

Access the website again, enter the fields, and proceed to log in.
![amplify-rewrite7](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/amplify-rewrite7.png)

In the image below, in the Network tab, we can see the response of the login request has returned a JSON from Backend instead of an HTML page as before.
![amplify-rewrite8](/images/5-Workshop/5.5-DeployFE/5.5.3-Connect-BE-FE/amplify-rewrite8.png)

So we have completed the necessary steps for Frontend and Backend to connect with each other. Next, we will refine the domain name so that users can search easily.