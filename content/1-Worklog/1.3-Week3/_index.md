---
title: "Week 3 Worklog"
weight: 1
chapter: false
pre: " <b> 1.3. </b> "
---

### Week 3 Objectives:
- Reinforce knowledge of VPC, EC2, IAM through repeated practice and resource cleanup.
- Deeply understand network connectivity mechanisms: Internet Gateway → Public EC2, NAT Gateway → Private EC2.
- Secure EC2 access methods: Bastion Host, Connect Endpoint, Session Manager.
- Secure Site-to-Site VPN and IAM through Lab practice.
- Get familiar with Windows EC2, custom AMI, Snapshot, keypair recovery, and deploy Node.js on both Linux & Windows.

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material | Note |
| ---- | ---- | ---------- | --------------- | ------------------ | ---- |
| 2 | - Delete all resources from the previous week.<br>- Re-practice Lab 000003 from scratch (entire):<br> • Create VPC, Subnet, IGW, NATGW, Route Table, SG<br> • Launch Public & Private EC2<br> • SSH via Bastion Host, Connect Endpoint, Session Manager<br> • Test Internet connectivity:<br>  – Public EC2 → via Internet Gateway<br>  – Private EC2 → via NAT Gateway<br> • Understand why configured this way | 09/22/2025 | 09/22/2025 | https://000003.awsstudygroup.com/ | Reinforce network architecture |
| 3 | - Watch Module 02 (advanced part).<br>- Practice Lab 000003 – Site-to-Site VPN:<br> • Create Customer Gateway, Virtual Private Gateway<br> • Configure VPN Connection<br> • Verify connectivity<br> • Clean up resources | 09/23/2025 | 09/23/2025 | https://www.youtube.com/playlist?list=PLahN4TLWtox2a3vElknwzU_urND8hLn1i (Module 02)<br>AWS VPN Docs | Hybrid network connectivity |
| 4 | - Study and acknowledge AWS IAM (Users, Groups, Roles, Policies, MFA).<br>- Practice Lab 000002:<br> • Create IAM User, Group, Role<br> • Attach Policy (inline & managed)<br> • Enable MFA<br> • Test access permissions<br> • Clean up | 09/24/2025 | 09/24/2025 | https://000002.awsstudygroup.com/ | Access management |
| 5 | - Translate personal blog (Vietnamese translation + original English). | 09/25/2025 | 09/25/2025 |  |  |
| 6.1 | - Watch Module 03.<br>- Practice Lab 000004 (part 1):<br> • Create VPC + Security Group prepared for Linux & Windows<br> • Launch EC2 Windows Instance<br> • Launch EC2 Linux Instance<br> • Clean up resources | 09/26/2025 | 09/26/2025 | https://000004.awsstudygroup.com/ |  |
| 6.2 | - Complete Lab 000004 (part 2):<br> • Change instance type<br> • Create Snapshot → Custom AMI<br> • Lost keypair → recover using Systems Manager<br> • Deploy Node.js app on:<br>  – EC2 Linux (User Data + PM2)<br>  – EC2 Windows (IIS or direct Node)<br> • Clean up everything | 09/26/2025 | 09/26/2025 | https://000004.awsstudygroup.com/ |  |
### Week 3 Achievements:
- Fully Acknowledged multi-tier VPC architecture:
  - Clearly understood why use IGW for Public, NATGW for Private.
  - Proficiently practiced 3 EC2 connection methods:
    - Bastion Host → traditional, requires port 22 open
    - Connect Endpoint → private-only, no public IP needed
    - Session Manager → no SSH key, audit log, IAM control
- Acknowledged Site-to-Site VPN:
  - Configured on-premise ↔ AWS VPC connection.
  - Verified ping, traceroute through tunnel.
- Acknowledge AWS IAM:
  - Created and managed User, Group, Role, Policy.
  - Applied MFA, Least Privilege, Policy Conditions.
- Completed high-quality blog translation with accurate summary and technical terminology.
- Acknowledged advanced EC2:
  - Compared Linux vs Windows EC2 (RDP vs SSH).
  - Created Custom AMI from Snapshot.
  - Recovered access when keypair lost using Session Manager.
  - Successfully deployed Node.js app on both Linux (systemd/PM2) and Windows (NSSM/IIS).
- Completed Lab 000002, 000003 (VPN), 000004 with all requirements.