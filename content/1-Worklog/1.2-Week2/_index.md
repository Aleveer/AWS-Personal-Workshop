---
title: "Week 2 Worklog"
weight: 1
chapter: false
pre: " <b> 1.2. </b> "
---

### Week 2 Objectives:
- Review Lab 000001 and deepen understanding of AWS cost management.
- Acknowledge VPC networking concepts and build secure network architectures.
- Gain hands-on experience with EC2 connectivity, security, and reachability analysis.
- Practice secure access methods to EC2 instances.

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material | Note |
| --- | ---- | ---------- | --------------- | ------------------ | ---- |
| 2 | - Review Lab 000001.<br>- Complete Lab 000007: Manage costs with AWS Budgets – create budgets using templates for Cost, Usage, and Savings Plans.<br>- Perform cleanup of created resources.<br>- (Earn $20 reward upon Budget creation) | 09/15/2025 | 09/15/2025 | https://000007.awsstudygroup.com/ | Cost control & cleanup |
| 3 | - Watch Module 02 videos and take notes on core concepts:<br> • VPC<br> • Subnet (Public & Private)<br> • Route Table<br> • Interface/Gateway Endpoints<br> • Internet Gateway / NAT Gateway | 09/16/2025 | 09/16/2025 | https://www.youtube.com/playlist?list=PLahN4TLWtox2a3vElknwzU_urND8hLn1i (Module 02) | Networking fundamentals |
| 4 | - Complete Lab 000003.3:<br> • Create VPC<br> • Create Public and Private Subnets<br> • Attach Internet Gateway<br> • Configure Route Table<br> • Create Security Groups | 09/17/2025 | 09/17/2025 | https://000003.awsstudygroup.com/vi/ | Network foundation setup |
| 5 | - Continue Lab 000003 (remaining parts):<br> • Launch EC2 instances in Public and Private Subnets<br> • SSH into Public EC2 → Private EC2<br> • Test Internet connectivity from both instances<br> • Use Reachability Analyzer to verify connectivity between the two EC2s | 09/18/2025 | 09/18/2025 | https://000003.awsstudygroup.com/ | EC2 networking & troubleshooting |
| 6 | - Practice and compare 3 EC2 connection methods:<br> 1. Bastion Host (Jump Server)<br> 2. VPC Interface Endpoint + EC2 Instance Connect<br> 3. AWS Systems Manager – Session Manager<br>- Document pros/cons and security implications | 09/19/2025 | 09/19/2025 | https://000003.awsstudygroup.com/ | Secure remote access |

### Week 2 Achievements:
- Successfully reviewed Lab 000001 and applied best practices in resource management.
- Acknowledged AWS Budgets:
  - Created Cost, Usage, and Savings Plans budgets using templates.
  - Performed full resource cleanup to control costs.
  - Earned $20 credit from AWS Budget task.
- Gained deep understanding of AWS VPC networking:
  - Clearly distinguished Public vs Private Subnets, Route Tables, Internet/NAT Gateways, and Endpoints.
  - Built a complete, functional multi-tier VPC architecture.
- Hands-on with EC2 in isolated networks:
  - Launched and configured EC2 instances in both public and private subnets.
  - Validated SSH chaining and Internet access behavior.
  - Used Reachability Analyzer to diagnose and confirm network paths.
- Acknowledged secure EC2 access methods:
  - Implemented and compared:
    - Bastion Host (traditional SSH jump)
    - EC2 Instance Connect Endpoint (private-only access)
    - Session Manager (agentless, IAM-controlled, audit-ready)
  - Understood trade-offs in security, convenience, and auditability.
- Fully completed Labs 000007 and 000003 with all objectives met.