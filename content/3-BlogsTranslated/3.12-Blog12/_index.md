---
title: "Blog 12"
weight: 2
chapter: false
pre: " <b> 3.12. </b> "
---

# Introducing Amazon EBS Volume Clones: Create instant copies of your EBS volumes

As someone that used to work at [Sun Microsystems](https://en.wikipedia.org/wiki/Sun_Microsystems), where [ZFS](https://en.wikipedia.org/wiki/ZFS) was invented, I’ve always loved working with storage systems that offer instant volume copies for my development and testing needs.

Today, I’m excited to share that AWS is bringing similar capabilities to [Amazon Elastic Block Store (Amazon EBS)](https://aws.amazon.com/ebs/) with the launch of Amazon EBS Volume Clones, a new capability that lets you create instant point-in-time copies of your EBS volumes within the same Availability Zone.

Many customers need to create copies of their production data to support development and testing activities in a separate nonproduction environment. Until now, this process required taking an EBS snapshot (stored in [Amazon Simple Storage Service (Amazon S3)](https://aws.amazon.com/s3/)) and then creating a new volume from that snapshot. Although this approach works, the process creates operational overhead due to multiple steps.

With Amazon EBS Volume Clones, you can now create copies of your EBS volumes with a single API call or console click. The copied volumes are available within seconds and provide immediate access to your data with single-digit millisecond latency. This makes Volume Clones particularly useful for quickly setting up test environments with production data or creating temporary copies of databases for development purposes.

### Let me show you how Volume Clones works

For this post, I created a small [Amazon Elastic Compute Cloud (Amazon EC2)](https://aws.amazon.com/ec2/) instance, with an attached volume. I created a file on the root file system with the command echo `"Hello CopyVolumes" > hello.txt`.

To initiate the copy, I open a browser on the [AWS Management Console](https://console.aws.amazon.com/) and I navigate to __EC2__, __Elastic Block Store__, __Volumes__. I select the volume I want to copy.

Note that, at the time of publication of this post, only encrypted volumes can be copied.

On the __Actions__ menu, I choose the __Copy Volume__ option.

![](/images/3-BlogsTranslated/3.12-Blog12/IMG_1.png)

Next, I choose the details of the target volume. I can change the __Volume type__ and adjust the __Size__, __IOPS__, and __Throughput__ parameters. I choose __Copy volume__ to start the Volume Clone operation.

![](/images/3-BlogsTranslated/3.12-Blog12/IMG_2.png)

The copied volume enters the __Creating__ state and becomes available within seconds. I can then attach it to an EC2 instance and start using it immediately.

Data blocks are copied from the source volume and written to the volume copy in the background. The volume remains in the __Initializing__ state until the process is complete. I can monitor its progress with the `describe-volume-status` [API](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeVolumeStatus.html). The initializing operation doesn’t affect the performance of the source volume. I can continue using it normally during the copy process.

I love that the copied volume is available immediately. I don’t need to wait for its initialization to complete. During the initialization phase, my copied volume delivers performance based on the lowest of: a baseline of 3,000 IOPS and 125 MiB/s, the source volume’s provisioned performance, or the copied volume’s provisioned performance.

After initialization is completed, the copied volume becomes fully independent of the source volume and delivers its full provisioned performance.

![](/images/3-BlogsTranslated/3.12-Blog12/IMG_3.png)

Alternatively, I can use the [AWS Command Line Interface (AWS CLI)](https://aws.amazon.com/cli/) to initiate the copy:

```Bash
aws ec2 copy-volumes                          \
     --source-volume-id vol-1234567890abcdef0 \
     --size 500                               \
     --volume-type gp3
```

After the volume copy is created, I attach it to my EC2 instance and mount it. I can check the file I created at start is present.

First, I attach the volume from my laptop, using the `attach-volume` command:

```Bash
aws ec2 attach-volume \
         --volume-id 'vol-09b700e3a23a9b4ad' \
         --instance-id 'i-079e6504ad25b029e'   \
         --device '/dev/sdb'
```

Then, I connect to the instance, and I type these commands:

```Bash
$ sudo lsblk -f
NAME          FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
nvme0n1                                                                              
├─nvme0n1p1   xfs          /     49e26d9d-0a9d-4667-b93e-a23d1de8eacd    6.2G    22% /
└─nvme0n1p128 vfat   FAT16       3105-2F44                               8.6M    14% /boot/efi
nvme1n1                                                                              
├─nvme1n1p1   xfs          /     49e26d9d-0a9d-4667-b93e-a23d1de8eacd                
└─nvme1n1p128 vfat   FAT16       3105-2F44     

$ sudo mount -t xfs /dev/nvme1n1p1 /data

$ df -h
Filesystem        Size  Used Avail Use% Mounted on
devtmpfs          4.0M     0  4.0M   0% /dev
tmpfs             924M     0  924M   0% /dev/shm
tmpfs             370M  476K  369M   1% /run
/dev/nvme0n1p1    8.0G  1.8G  6.2G  22% /
tmpfs             924M     0  924M   0% /tmp
/dev/nvme0n1p128   10M  1.4M  8.7M  14% /boot/efi
tmpfs             185M     0  185M   0% /run/user/1000
/dev/nvme1n1p1    8.0G  1.8G  6.2G  22% /data

$ cat /data/home/ec2-user/hello.txt 
Hello CopyVolumes
```

### Things to know

Volume Clones creates copies within the same Availability Zone as your source volume. You can create copies from encrypted volumes only, and the size of your copy must be equal to or greater than the source volume.

Volume Clones creates crash-consistent copies of your volumes, exactly like snapshots. For application consistency, you need to pause application I/O operations before creating the copy. For example, with PostgreSQL databases, you can use the `pg_start_backup()` and `pg_stop_backup()` functions to pause writes and create a consistent copy. At the operating system level on Linux with XFS, you can use the `xfs_freeze` command to temporarily suspend and resume access to the file system and ensure all cached updates are written to disk.

Although Volume Clones creates point-in-time copies, it complements rather than replaces EBS snapshots for backup purposes. EBS snapshots remain the recommended solution for data backup and protection against AZ-level and volume failures. Snapshots provide incremental backups to Amazon S3 with 11 nines of durability, compared to Volume Clones which maintains EBS volume durability (99.999% for io2, 99.9% for other volume types). Consider using Volume Clones specifically for test and development environment scenarios where you need instant access to volume copies.

Copied volumes exist independently of their source volumes and continue to incur standard EBS volume charges until you delete them. To manage costs effectively, implement governance rules to identify and remove copied volumes that are no longer needed for your development or testing activities.

### Pricing and availability

Volume Clones supports all EBS volume types and works with volumes in the same AWS account and Availability Zone. This new capability is available in all AWS commercial [Regions](https://docs.aws.amazon.com/glossary/latest/reference/glos-chap.html#region), selected [Local Zones](https://aws.amazon.com/about-aws/global-infrastructure/localzones/locations/), and in the [AWS GovCloud (US)](https://aws.amazon.com/govcloud-us/).

For pricing, you’re charged a one-time fee per GiB of data on the source volume at initiation and standard EBS pricing for the new volume.

I find Volume Clones particularly valuable for database workloads and continuous integration (CI) scenarios. For instance, you can quickly create a copy of your production database for testing new features or troubleshooting issues without impacting your production environment or waiting for data to hydrate from Amazon S3.

To get started with Amazon EBS Volume Clones, visit the [Amazon EBS section on the console](https://console.aws.amazon.com/ec2/home#Volumes:) or check out the [EBS documentation](https://docs.aws.amazon.com/ebs/latest/userguide/ebs-copying-volume.html). I look forward to hearing how you use this capability to improve your development workflows.