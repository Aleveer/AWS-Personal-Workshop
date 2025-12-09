---
title : "Configure Custom Domain with Route53 and SSL verification with AWS Certificate Manager"
weight : 3
chapter : false
pre : " <b> 5.5.3 </b> "
---
#### Prepare your Domain

First, you need to buy a Domain from any Domain provider you want; here I bought a Domain named webchat.mom from Porkbun.
![prepare-domain](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/prepare-domain.png)

#### Create a Hosted Zone in Route53 and point that Domain to this HostedZone.

Access Route53 and select Create hosted zones -> Get Started
Enter the domain name you bought into the Domain Name box. Then click Create hosted zone.
![hosted-zone](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone.png)

Enter the domain name you bought into the Domain Name box. Then click Create hosted zone.
![hosted-zone1](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone1.png)

After creating the Hosted Zone, click on the newly created Hosted zone details, then copy the 4 Name Servers lines.
![hosted-zone2](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone2.png)

Return to the Domain management page where you bought the Domain; here I bought it at Porkbun, I will proceed to change the 4 Name Servers of the domain to the 4 Name Servers of the Hosted Zone. Select NameServers
![hosted-zone3](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone3.png)

Delete the 4 existing DNS in NameServers.
![hosted-zone4](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone4.png)

Replace with the 4 DNS of the Hosted Zone from earlier. Then click Submit.
![hosted-zone5](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone5.png)

### Request certificate for Domain with Amazon Certificate Manager
Access Amazon Certificate Manager, select Request a certificate.
![acm](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/acm.png)

Select Request a public certificate, then click Next.
![acm1](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/acm1.png)

We proceed to enter the Domain into Domain names, with line 1 being the Domain for the backend and Domain 2 being for the frontend.
![acm2](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/acm2.png)

Scroll down and select Request.
![acm3](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/acm3.png)

Select Create records in Route53 and click Create Record to add those 2 Domain lines to Route53's Hosted Zone.
![acm4](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/acm4.png)

Select the 2 Domains and click Create records.
![acm5](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/acm5.png)

Wait a few minutes for the status to complete creating the Certificate.
![acm6](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/acm6.png)

Return to Route53, find the created Hosted Zone, proceed to select Create record to create an Alias to the Backend ALB's DNS.
![hosted-zone6](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone6.png)

Proceed to enter the subdomain for the backend and enable Alias, then select Alias to Application and Classic Load Balancer, then select the Region and ALB you created earlier for the Backend. Then click Create records.
![hosted-zone7](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone7.png)

We have completed the DNS configuration on Route 53 by creating an Alias record pointing the domain api.webchat.mom to the Application Load Balancer.
![hosted-zone8](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone8.png)

So we have completed the setup and issuance of SSL certificates for the purchased Domain. Next, we will configure the necessary steps to connect Frontend and Backend.