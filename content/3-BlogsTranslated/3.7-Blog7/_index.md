---
title: "Blog 7"
weight: 1
chapter: false
pre: " <b> 3.7. </b> "
---

# GNOME has a new infrastructure partner: welcome AWS!

_This post was contributed by Andrea Veri from the GNOME Foundation. It has been [cross-posted from gnome.org](https://blogs.gnome.org/foundation/2025/06/10/gnome-has-a-new-infrastructure-partner-welcome-aws/) with permission._

[GNOME](https://foundation.gnome.org/) has historically hosted its infrastructure on premises. That changed with an [AWS Open Source Credits program](https://aws.amazon.com/blogs/opensource/aws-cloud-credits-for-open-source-projects-affirming-our-commitment/) sponsorship which has allowed our team of two SREs to migrate the majority of the workloads to the cloud and turn the existing Openshift environment into a fully scalable and fault tolerant one thanks to the infrastructure provided by AWS. By moving to the cloud, we have dramatically reduced the maintenance burden, achieved lower latency for our users and contributors and increased security through better access controls.

Our original infrastructure did not account for the exponential growth that GNOME has seen in its contributors and userbase over the past 4-5 years thanks to the introduction of [GNOME Circle](https://circle.gnome.org/). GNOME Circle is composed of applications that are not part of core GNOME but are meant to extend the ecosystem without being bound to the stricter core policies and release schedules. Contributions on these projects also make contributors [eligible for GNOME Foundation membership](https://handbook.gnome.org/foundation/membership-benefits.html) and potentially allow them to receive direct commit access to GitLab in case the contributions are consistent over a long period of time in order to gain more trust from the community. GNOME recently migrated to GitLab, away from cgit and Bugzilla.

In this post, we’d like to share some of the improvements we’ve made as a result of our migration to the cloud.

## A history of network and storage challenges

In 2020, we documented our main architectural challenges:

1. Our infrastructure was built on OpenShift in a hyperconverged setup, using OpenShift Data Foundations (ODF), running Ceph and Rook behind the scenes. Our control plane and workloads were also running on top of the same nodes.
2. Because GNOME historically did not have an L3 network and generally had no plans to upgrade the underlying network equipment and/or invest time in refactoring it, we would have to run our gateway using a plain Linux VM with all the associated consequences.
3. We also wanted to make use of an external Ceph cluster with slower storage, but this was not supported in ODF and required extra glue to make it work.
4. No changes were planned on the networking equipment side to make links redundant. That meant a code upgrade on switches would have required full service downtime.
5. We had to work with with Dell support for every broken hardware component, which added further toil.
6. With the GNOME user and contributor base always increasing, we never really had a good way to scale our compute resources due to budget constraints.

## Cloud migration improvements

In 2024, during a hardware refresh cycle, we started evaluating the idea of migrating to the public cloud. We have been participating in the AWS Open Source Credits program for many years and received sponsorship for a set of Amazon Simple Storage Service (Amazon S3) buckets that we use widely across GNOME services. Based on our previous experience with the program and the people running it, we decided to request sponsorship from AWS for the entire infrastructure which was kindly accepted.

I believe it’s crucial to understand how AWS resolved the architectural challenges we had as a small SRE team (just two engineers!). Most importantly, the move dramatically reduced the maintenance toil we had:

1. Using AWS’s provided software-defined networking services, we no longer have to rely on an external team to apply changes to the underlying networking layout. This also gave us a way to use a redundant gateway and NAT without having to expose worker nodes to the internet.
2. We now use AWS Elastic Load Balancing (ELB) instances (classic load balancers are the only type supported by OpenShift for now) as a traffic ingress for our OpenShift cluster. This reduces latency as we now operate within the same VPC instead of relying on an external load balancing provider. This also comes with the ability to have access to the security group APIs which we can use to dynamically add IPs. This is critical when we have individuals or organizations abusing specific GNOME services with thousands of queries per minute.
3. We also use Amazon Elastic Block Store (Amazon EBS) and Amazon Elastic File System (Amazon EFS) via the OpenShift CSI driver. This allows us to avoid having to manage a Ceph cluster, which is a major win in terms of maintenance and operability.
4. With AWS Graviton instances, we now have access to ARM64 machines, which we heavily leverage as they’re generally cheaper than their Intel counterparts.
5. Given how extensively we use Amazon S3 across the infrastructure, we were able to reduce latency and costs due to the use of internal VPC S3 endpoints.
6. We took advantage of AWS Identity and Access Management (IAM) to provide granular access to AWS services, giving us the possibility to allow individual contributors to manage a limited set of resources without requiring higher privileges.
7. We now have complete hardware management abstraction, which is vital for a team of only two engineers who are trying to avoid any additional maintenance burden.

## Thank you, AWS!

I’d like to thank AWS for their sponsorship and the massive opportunity they are giving to the GNOME Infrastructure to provide resilient, stable and highly available workloads to GNOME’s users and contributors across the globe.