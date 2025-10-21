---
title: "Blog 6"
weight: 1
chapter: false
pre: " <b> 3.6. </b> "
---

# Optimizing Unicode Conversion Downtime for SAP Systems on Oracle to AWS

Global organizations using SAP systems need to handle data in multiple languages. [Unicode](https://www.unicode.org/standard/WhatIsUnicode.html) provides a standardized way to represent and process text data from these languages, ensuring consistent display and processing across different systems and platforms. SAP recommends using Unicode for all new installations and converting from non-Unicode systems to ensure compatibility, data integrity, and support for global operations. The latest SAP releases, such as [SAP ERP 6.0 EHP8](https://help.sap.com/docs/SAP_ERP) and [SAP S/4HANA](https://help.sap.com/docs/SAP_S4HANA_ON-PREMISE), are only available in Unicode, making it a prerequisite for the source system to be Unicode-compatible before upgrading to a higher release.

To ensure a smooth transition to SAP S/4HANA, customers need to prioritize the adoption of Unicode in their systems, considering the mainstream maintenance support for ERP 6.0 is scheduled to end on December 31, 2027 as per [SAP Note 1648480](https://me.sap.com/notes/1648480) – Maintenance for SAP Business Suite 7 Software including SAP NetWeaver (SAP Support login required).

Converting SAP systems to Unicode involves managing multiple technical challenges: data conversion, code remediation, planned downtime, testing and validation, performance impact, and interface adjustments. Large SAP databases (10 TB+) require 1-3 days of downtime for Unicode conversion. The process needs additional hardware capacity to minimize downtime. Organizations with end-of-life infrastructure must balance hardware investments against downtime requirements.

In this blog, we address the challenges faced by a customer regarding system downtime and present a use case where [Bell Canada](https://d1.awsstatic.com/events/Summits/toronto24/TEL201_TurbochargingSAP_E2_TORSummit_20240911.pdf), one of Canada’s largest telecommunications companies, followed an alternative approach to migrate their 11 TB non-Unicode SAP ERP system running with an Oracle database to AWS in under 5 hours.

## Background

Customers running their non-Unicode SAP ERP systems with Oracle databases must first convert their SAP non-Unicode (NUC) systems to Unicode (UC) before migrating to S/4HANA as per [SAP Note 2033243](https://me.sap.com/notes/2033243/E). Additionally, when migrating SAP systems running on Oracle databases to AWS, customers must convert to Unicode systems for supportability reasons, as outlined in [SAP Note 2358420](https://me.sap.com/notes/2358420).

In such case, customers undertake a Unicode conversion as an initial step when migrating to AWS. Once the system is operational on AWS, they upgrade from SAP ECC to S/4HANA, taking advantage of AWS’s scalable cloud services.

For Unicode conversions, the documented SAP procedure involves exporting the SAP system data from the on-premises source system, transferring the exported data to AWS using services such as [AWS Direct Connect](https://aws.amazon.com/directconnect/) or [AWS Site-to-Site VPN](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html), and then importing it into the target system running on AWS. The exact duration varies based on factors such as hardware capacity, available network bandwidth, migration tools employed, and specific methods utilized.

When dealing with SAP workloads, which involve multiple third-party integrations, minimizing downtime is necessary to ensure business continuity and prevent disruptions to critical processes. Consequently, it’s essential to adopt strategies and techniques that can minimize the migration downtime.

## Use Case

Bell Canada was operating their SAP ERP system with an on-premises Oracle 19c Database with Red Hat Enterprise Linux 8 (RHEL8) as the operating system. The production database size was approximately 11 TB. Bell Canada wanted to retain the Oracle database and upon migrating to AWS, it is required to have an Oracle Enterprise Linux operating system for Oracle support, as per [SAP Note 2358420](https://me.sap.com/notes/2358420). Additionally, the SAP system needed to be converted to Unicode. The approved maximum business downtime for the migration was 32 hours, with a maximum of 10 hours allowed for technical conversion.

We identified a migration approach that eliminates additional on-premises hardware and follows best practices for AWS transitions. The plan prioritizes minimal technical conversion downtime while allocating more time for cutover tasks. We also evaluated different migration options and the best practices such as utilizing advanced database features, parallel processing, or other optimization techniques.

## Migration approach

Let’s explore the available approaches available for migrating a non-Unicode SAP system with an Oracle database (running on RHEL) to Oracle Enterprise Linux on AWS.

| Approach | Description | Steps |
|  --  |  --  |  |
| Option 1 | Unicode conversion along with migration to AWS staying on an Oracle database | * Migrate the SAP system from the on-premises data center to AWS, converting from non-Unicode to Unicode during the process.<br>* Perform remediation and testing of the SAP system on AWS, then decommission the on-premises SAP system. |
| Option 2 | Migrate non-Unicode SAP to AWS, then convert to Unicode while staying on an Oracle database | - Migrate the SAP system from the on-premises data center to AWS using asynchronous database replication in a temporary system until the cutover.<br>- Convert from non-Unicode to Unicode on AWS by exporting from the temporary system and importing into the final system.<br>- Perform remediation and testing of the SAP system on AWS, then decommission the on-premises SAP system and the temporary system. |

Table 1: Unicode conversion options for SAP on Oracle to AWS

Both migration options require a business downtime window to transition to the target AWS environment. While Option 1 offers a more predictable execution approach, it requires additional on-premises hardware to support resource-intensive export processes during the SAP Unicode conversion and a stable network bandwidth to facilitate data transfer from on-premises to AWS. Furthermore, this option demands more than 24 hours of technical downtime. To address these challenges, we’ll explore Option 2 and discuss it’s migration approach and best practices.

In Option 2, a non-Unicode SAP vanilla system is provisioned on [Amazon Elastic Compute Cloud (Amazon EC2)](https://aws.amazon.com/ec2/) as a temporary instance, and a Unicode SAP installation is set up on another [Amazon EC2](https://aws.amazon.com/ec2/) as the final instance. The staging instance should be configured with the same version of Oracle database software, including the release and patch set, as the on-premises environment. According to [SAP Note 1571295](https://me.sap.com/notes/1571295/E) new non-Unicode SAP system installations are not permitted by default. Therefore, the initial non-Unicode SAP system is created by performing a system copy export from a small existing non-Unicode system. This system copy export is done only once, and the resulting export is reused to build any non-Unicode SAP systems across all environments. The source on-premises SAP system is migrated to the staging instance on AWS using asynchronous database replication. For Oracle database replication, [Oracle Data Guard](https://www.oracle.com/in/database/data-guard/) (ODG) is utilized, which is included in Oracle Enterprise Edition licenses which are included in purchases from SAP. This asynchronous replication facilitates the data transfer from on-premises to AWS without impacting ongoing business operations. This method allows terabyte-scale data transfer to AWS during normal business operations. At the start of the actual downtime window, the staging instance takes over and serves as the source system for the Unicode conversion. The SAP system export is performed on the staging instance, and the import is executed on the final SAP instance.

Let’s examine a simplified architectural setup as shown in Figure 1 to understand the migration process for this approach.

![Simplified architectural setup for Unicode conversion and migration](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/10/Simplified-architectural-setup-for-Unicode-conversion-and-migration2.jpg)

**Figure 1: Simplified architectural setup for Unicode conversion and migration**

In the first step, Oracle Data Guard is configured for data synchronization between the on-premises database and the staging instance on AWS. Data is transferred from the on-premises environment to the staging instance over [AWS Direct Connect](https://aws.amazon.com/directconnect/). The replication process continues until the start of the cutover process during the downtime window. After taking over the database on the staging instance, it becomes the source system for the SAP system export. In the second step, the SAP system copy export, including any necessary preparation like table splitting, is initiated on the staging database instance. The export dump is stored on an [Amazon Elastic Block Store (Amazon EBS)](https://aws.amazon.com/ebs/) volume attached to the staging instance (referred to as sapdump) and Oracle data files are stored on the EBS volumes (referred to as sapdata). In the third step, the export dump files are continuously transferred to the [Amazon EBS](https://aws.amazon.com/ebs/) volume attached to the final instance using File Transfer Protocol (FTP) without manual intervention. In the fourth step, the import process is started on the final database instance, running in parallel with the export process. By employing a parallel migration approach using SAP tools like [Software Provisioning Manager](https://help.sap.com/docs/SOFTWARE_PROVISIONING_MANAGER) (SWPM) and [SAP Migration Monitor](https://help.sap.com/doc/3a697dba3b544d3ab0db197f753088b1/CURRENT_VERSION/en-US/MigrationMonitor7xx.pdf), export/import process are parallelized. After completing the export/import, the target SAP system is started, and post-processing steps are performed on the final instance. Subsequently, the staging instance is shut down and eventually terminated.

The above simplified diagram in Figure 1 does not include components related to high availability (HA) setup for the sake of simplicity. However, production systems need high availability configurations depending on business requirements. For information on setting up high availability with an Oracle database on AWS for SAP NetWeaver installations, please refer to the blog [High availability design and solution for SAP NetWeaver installations with Oracle Data Guard (Fast-Start Failover)](https://aws.amazon.com/blogs/awsforsap/high-availability-design-and-solution-for-sap-netweaver-installations-with-oracle-data-guard-fast-start-failover/).

Customers should obtain SAP’s concurrence for temporarily running the non-Unicode SAP system during the cutover duration (without any end-users on it) and validate the approach through a proof of concept (POC) at the beginning of the project.

## Best practices

Let’s delve into the best practices which helped in minimizing downtime during the technical conversion. To better understand this, we will examine the guidelines and practices that are implemented in each phase of the system migration. Figure 2 shows the high-level phases for Unicode conversion and migration of an SAP system based on Oracle.

![Phases in SAP system Unicode conversion and migration based on Oracle](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/10/Phases-in-SAP-system-Unicode-conversion-and-migration-based-on-Oracle.jpg)

**Figure 2: Phases in an SAP system Unicode conversion and migration based on Oracle**

### Planning

During the planning phase, we recommend considering strategies to reduce the size of large technical tables. Cross-check if standard reorganization jobs are scheduled to prevent the technical tables from growing indefinitely. For instance, following the guidelines in [SAP Note 1616768](https://me.sap.com/notes/1616768/E) for the BALDAT and BALHDR tables will be beneficial if these log tables have become excessively large.

The Unicode conversion process requires specific preparatory checks, including long-running reports like SDBI_CLUSTER_CHECKS and UCCHECK. We advise running these reports months in advance before the actual conversion. This proactive approach helps identify and mitigate potential issues related to cluster tables and provides insights into the development efforts required for Unicode-related adjustments. These checks are part of the Unicode conversion guide as referred in [SAP Note 551344](https://me.sap.com/notes/551344/E).

When transitioning to Unicode and preparing for the target infrastructure, you must assess the Unicode-related hardware requirements specified in [SAP Note 1139642](https://me.sap.com/notes/1139642/E). Migrating terabytes of data will need a reliable network connection with required bandwidth between the on-premises source and AWS, which is achieved by [AWS Direct Connect](https://aws.amazon.com/directconnect/) or [AWS Site-to-Site VPN](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html).

Open the required ports for SAP services and the Oracle database in the associated firewall and [security group](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html) to maintain consistent network access throughout the migration process. For SAP services, such as the SAP Application Server, SAP Central Services, and SAP Software Provisioning Manager (SWPM), refer to the SAP documentation “ [TCP/IP Ports of All SAP Products](https://help.sap.com/docs/Security/575a9f0e56f34c6e8138439eefc32b16/616a3c0b1cc748238de9c0341b15c63c.html)“. For Oracle database and Oracle Data Guard replication, open the [Oracle Net Services Listener port](https://docs.oracle.com/en/database/oracle/oracle-database/19/ladbi/oracle-database-component-port-numbers-and-protocols.html) configured for Oracle client connections to the database, LOCAL_LISTENER port configured for application pluggable databases (PDB) in a [multi-tenant architecture](https://docs.oracle.com/en/database/oracle/oracle-database/19/multi/introduction-to-the-multitenant-architecture.html) container database (CDB), as well as ports for Oracle Data Guard listener, if not using the standard Oracle Net listener ports. All these ports are manually configurable, and you should obtain the actual port numbers in use from the existing setup.

If the source database is encrypted, create the required [Oracle Wallet](https://docs.oracle.com/en/database/oracle/oracle-database/19/dbimi/using-oracle-wallet-manager.html) on the target systems and copy all necessary SSL certificates from the Oracle Wallet of the source system. Additionally, the listener services need to be configured to listen on the TCPS protocol instead of the standard TCP protocol. These protocol changes must be updated in the firewall configurations made earlier.

During the migration process, it is essential to monitor the total CPU and IOPS (Input/Output Operations Per Second) usage. Depending on the anticipated usage of CPU and IOPS during the migration, request an increase in the AWS service limits. When upsizing the instance type to accommodate more CPU during migration, ensure that your AWS account’s EC2 instance limit quota for the target region allows for the desired instance type and CPU capacity. For example, migration requirements of 250,000 IOPS exceed the default service quotas of 100,000 for “IOPS for Provisioned IOPS SSD (io2) volume” and “IOPS modifications for Provisioned IOPS SSD (io2) volumes”. In such cases, you should proactively request an increase in these quotas to the required value before initiating the migration. Review quota and limit details in the [Amazon EC2 quotas](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-resource-limits.html) and [Amazon EBS limits](https://docs.aws.amazon.com/general/latest/gr/ebs-service.html) documentation.

While migrating to Unicode, SAP system parameters for the target Unicode system will need to be adapted as outlined in [SAP Note 790099](https://me.sap.com/notes/790099/E). Depending on the support contract with SAP, you should consider using the “Going Live Functional Upgrade service” provided by SAP, which offers baseline recommendations for the Unicode system. [SAP Note 2360708](https://me.sap.com/notes/2360708) provides more information about how to request support service from SAP. Consider implementing the parameter changes early in the non-production environment before commencing the user acceptance testing. This proactive approach allows the business and technical teams to assess the impact of these changes and plan better for similar parameter adjustments in the production environment.

### System build

During the build phase, infrastructure is provisioned for both non-Unicode and Unicode SAP systems. The non-Unicode system serves as a temporary staging instance, utilized solely during the migration process, while the Unicode system serves as the final instance. Once the infrastructure is ready, SAP vanilla builds are performed for both the non-Unicode and Unicode systems. Building these vanilla systems allows for the execution of preparatory technical checks, such as high availability testing, in advance. As always, make sure to leverage the flexible benefits of the cloud to shut down your EC2 instances when they are not in use, which will help lower your hardware costs.

When designing the database disk layout, plan the number of [Amazon EBS](https://aws.amazon.com/ebs/) volumes, the [Amazon EBS volume types](https://docs.aws.amazon.com/ebs/latest/userguide/ebs-volume-types.html) such as General Purpose SSD (gp3) or Provisioned IOPS SSD (io2), and the required striping with Logical Volume Manager (LVM) to optimize throughput performance.

Lastly, check your EC2 limitations. As stated in [Amazon EBS-optimized instance types](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-optimized.html) user guide, “An instance’s EBS performance is bounded by the instance type’s performance limits, or the aggregated performance of its attached volumes, whichever is smaller”. If your workload requires high and consistent IOPS performance, low latency, high durability, and you’re willing to pay a premium, io2 volumes are the better choice. However, if your workload has moderate IOPS requirements and cost is a concern, gp3 volumes are more cost-effective option while still providing good performance and durability. For more detailed information on the performance characteristics and use cases of gp3 and io2 volumes, you can refer to the AWS documentation on [Amazon EBS volume types](https://docs.aws.amazon.com/ebs/latest/userguide/ebs-volume-types.html).

Provisioned IOPS SSD (io2) volumes offer the highest durability and lowest latency among [Amazon EBS](https://aws.amazon.com/ebs/) volume types, making them suitable for mission-critical applications with demanding performance requirements. For more detailed information on Provisioned IOPS SSD (io2) volumes, including performance characteristics, provisioning, and best practices, please refer to the AWS documentation on [Provisioned IOPS SSD (io2) Block Express volumes](https://docs.aws.amazon.com/ebs/latest/userguide/provisioned-iops.html#io2-block-express).

An example disk layout is provided for an Oracle database instance in Table 2, consisting of two io2 [Amazon EBS](https://aws.amazon.com/ebs/) volumes of 6,300 GB and 110,000 IOPS each. With striping, this configuration offers a throughput ranging from 3437.5 MB/s to 8,000 MB/s.

| EBS Volumes | Volume Group | Volume Type | Description | File system | EBS Size (GB) | IOPS | EBS Throughput (at 16 KiB I/O size) | EBS Throughput (at 256 KiB I/O size) |
|-------------|--------------|-------------|-------------|-------------|---------------|------|------------------------------------|-------------------------------------|
| Volume 1   | VG-DB       | io2        | Database data files | /oracle/<SID>/sapdata<1..n> | 6,300 | 110,000 | 1,718.75 MB/s | 4,000 MB/s |
| Volume 2   | VG-DB       | io2        | Database data files |  | 6,300 | 110,000 | 1,718.75 MB/s | 4,000 MB/s |
| Total      |             |            |             |             | 12,600 | 220,000 | 3,437.5 MB/s | 8,000 MB/s |

Table 2: Sample disk layout for Oracle database instance

### ODG setup / Replication / Monitoring

Oracle’s native solution, [Oracle Data Guard](https://www.oracle.com/database/data-guard/) (ODG), are employed to create a transactionally consistent copy of the on-premises database on a staging database server in AWS. Initially, [Oracle Recovery Manager](https://docs.oracle.com/en/database/oracle/oracle-database/19/bradv/getting-started-rman.html) (RMAN) is utilized to create a clone of the on-premises database on the staging server. Subsequently, the [Data Guard Broker](https://docs.oracle.com/en/database/oracle/oracle-database/19/dgbkr/oracle-data-guard-broker-concepts.html) is configured for change data capture (CDC), ensuring that all data changes made to the on-premises database are captured and applied to the target staging database in real-time.

Parallel channels are employed to maximize the copy throughput. Since RMAN utilizes a dedicated large pool for backup and restore operations, the target staging database needs to be configured with LARGE_POOL_SIZE and SGA_MAX_SIZE parameters. IO server processes need to be added to the database writer (DBWR) to optimize the write process during the restore operation by leveraging the async IO capabilities of the operating system.

To further enhance the conversion process, just before the cutover, scale up the staging and target database [Amazon EC2](https://aws.amazon.com/ec2/instance-types/) instances to meet conversion requirements. Additionally, adjustments are required for Oracle database parameters, for example MEMORY_TARGET and MEMORY_MAX_TARGET in databases configured with automatic memory management, to fully utilize the additional resources. During the conversion, both the staging and target databases are set to NOARCHIVELOG mode to minimize the overhead associated with log archiving.

### Unicode uptime / Pre-Migration steps

The Unicode conversion is carried out as part of the SAP system copy procedure. During this process, the system is exported from the source in Unicode format and then imported into the target SAP system. The [SAP System Copy Guide](https://help.sap.com/doc/23afa39273d149f5b747805421f54017/CURRENT_VERSION/en-US/SystemCopy_71X_ux_abap.pdf), and the “Unicode conversion guide” as referred in [SAP Note 551344](https://me.sap.com/notes/551344/E)), provides detailed instructions for this process.

Before the Unicode export and import can take place, the system must undergo a series of preparatory checks, both during uptime and downtime periods. These checks are outlined in the Unicode conversion guide. The uptime checks and reports are executed on the on-premises system, while reports and checks that require system downtime are performed on the staging instance on AWS, after the system takeover.

### Ramp down

During the scheduled business downtime, the systems are gracefully locked out for end-users. Once the communication interfaces are stopped, the systems are prepared for the migration process. In this phase, preparatory tasks are performed as outlined in the [SAP system copy guide](https://help.sap.com/doc/23afa39273d149f5b747805421f54017/CURRENT_VERSION/en-US/SystemCopy_71X_ux_abap.pdf), including suspending batch jobs, disabling alerts, stopping background processing, addressing cancelled or pending updates, and clearing invalid temporary tables etc. These steps ensure a smooth migration by bringing the systems to a consistent state before the actual migration activities commence.

### Takeover

After confirming that the primary and standby systems are synchronized, the staging system (on AWS) is taken over. This takeover is validated using the Oracle Data Guard (ODG) [switchover](https://docs.oracle.com/en/database/oracle/oracle-database/19/dgbkr/examples-using-data-guard-broker-DGMGRL-utility.html#GUID-1403D1C3-8944-42D0-8BDA-21D695C7958A) procedure. Upon successful takeover, the ODG configuration is [removed](https://docs.oracle.com/en/database/oracle/oracle-database/19/dgbkr/examples-using-data-guard-broker-DGMGRL-utility.html#GUID-820B4A3F-6FA3-4CC7-A06E-27BE25AB66F4) to prevent any reverse communication from the target system to the on-premises environment. Subsequently, the instance type and database-related parameters are adjusted before initiating the system copy procedure.

### System copy (Export / Import / Monitor)

To optimize the system copy procedure, start with identifying the top tables from the system DB02 list and plan for splitting large tables (e.g. tables more than 20 GB in size). Techniques such as Package Splitting and Table Splitting are used to enable parallel processing of table exports and imports. Running the [SAP migration time analyzer](https://help.sap.com/doc/3a697dba3b544d3ab0db197f753088b1/CURRENT_VERSION/en-US/MigrationMonitor7xx.pdf) can provide a consolidated view of package exports and imports, allowing for the identification of further optimization opportunities. This optimization exercise may require multiple test runs to identify the right sequence.

For large tables, splitting may be necessary to process exports and imports in parallel. While you have the option to use either SAPup/R3ta (as per [SAP system copy guide section 2.6.4](https://help.sap.com/doc/23afa39273d149f5b747805421f54017/CURRENT_VERSION/en-US/SystemCopy_71X_ux_abap.pdf)) or a supported database-specific splitter, in the case of an Oracle-based system migration, consider using the Oracle splitter for efficient table splitting as per [SAP Note 1043380](https://me.sap.com/notes/1043380/E).

Oracle parameter settings and configurations (e.g., db_cache_size, pga_aggregate_target, processes, PSAPTEMP size, and disabling archive logging) for R3load-based system copy should be set according to the recommendations from [SAP Note 936441](https://me.sap.com/notes/936441/E).

During the migration export/import process, an EC2 instance with a higher number of CPUs, RAM, network, and storage throughput capacity should be chosen. Additionally, it is recommended to temporarily use io2 EBS Volumes with boosted provisioned IOPS values to reduce import time, which are converted back to gp3 later, during online operations. The selected instance size should have at least the number of CPUs required to run multiple R3load processes concurrently and also supports sufficient EBS throughput and IOPS to ensure your high throughput volumes are not throttled. As a rule of thumb, use three times the number of CPUs. For example, if you plan to run 300 R3load processes, choose an [Amazon EC2](https://aws.amazon.com/pm/ec2/) instance with minimum 100 vCPUs.

Resize the instance and adapt the parameters in each subsequent proof of concept (POC) run based on the findings. Plan for multiple iterations of POCs in a test or sandbox system with a similar database size as production. After several POC runs, you should have the optimal configuration of CPU, RAM, network bandwidth, EBS throughput, and IOPS required for completing the Unicode conversion within the desired technical downtime. Before the export and import activity, the instance type are changed to achieve optimal performance with higher CPU, memory, network performance, and maximum bandwidth. For example, the EC2 [r7i.48xlarge](https://aws.amazon.com/ec2/instance-types/r7i/), powered by 4th Generation Intel Xeon Scalable processors, provides 192 CPUs, 1536 GB of memory, 50 Gbps Network Bandwidth, 5000 MB/s Max EBS Throughput, and 240000 Max IOPS.

Monitoring the migration execution is necessary, and you can leverage [Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html) to create a dashboard for monitoring during the cutover. This will help identify any bottlenecks or indicate opportunities to further fine-tune the Unicode conversion downtime.

Using [Amazon CloudWatch dashboards](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Dashboards.html), you can monitor relevant [EBS metrics](https://docs.aws.amazon.com/ebs/latest/userguide/using_cloudwatch_ebs.html) for throughput (VolumeReadBytes, VolumeWriteBytes, or VolumeThroughputPercentage), and IOPS (VolumeReadOps, VolumeWriteOps, or VolumeConsumedReadWriteOps) for important volumes such as the sapdata volume (used for the Oracle sapdata file) and the sapdump volume (used for storing export/import data from the SAP system). Additionally, you can monitor CPU usage along with other metrics like throughput and IOPS. If the limits are not reached and the [SAP migration time analyzer](https://help.sap.com/doc/3a697dba3b544d3ab0db197f753088b1/CURRENT_VERSION/en-US/MigrationMonitor7xx.pdf) shows some tasks taking longer, you should increase the number of R3load processes and allow those slower tasks to be processed first during the export. You can control the order of export/import by orderBy properties as described in section 2.6.7 of the [SAP system copy guide](https://help.sap.com/doc/23afa39273d149f5b747805421f54017/CURRENT_VERSION/en-US/SystemCopy_71X_ux_abap.pdf).

It is recommended to monitor the volumes that hold the Oracle online redo logs, which might be used for logging mechanisms during export/import. This applies to both the staging database instance and the final database instance. By closely monitoring these metrics, you can identify potential bottlenecks and make informed decisions to optimize the Unicode conversion process, ensuring a smooth and efficient migration within the desired technical downtime.

Figure 3 illustrates an example of an [Amazon CloudWatch Dashboard](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Dashboards.html) displaying important metrics.

![Amazon CloudWatch Dashboard with important metrics](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/10/Amazon-CloudWatch-Dashboard-with-important-metrics.jpg)

**Figure 3: Amazon CloudWatch Dashboard with important metrics**

### Post-Migration steps

In this phase, all the post-Unicode conversion, post-migration activities as outlined in the SAP Unicode conversion guide as referred in [SAP Note 551344](https://me.sap.com/notes/551344/E) and [SAP system copy guide](https://help.sap.com/doc/23afa39273d149f5b747805421f54017/CURRENT_VERSION/en-US/SystemCopy_71X_ux_abap.pdf) are executed. Once these activities are completed, any optimizations made specifically for the migration (e.g., instance size, IOPS, throughput, SAP/database parameters) are reverted to their original settings.

Before handing over the system for user validation, ensure that a system backup is in place and fully operational. After the migration is completed and validated by the business, the staging system is shut down (and later terminated) to avoid incurring unnecessary costs.

Following the prescribed steps precisely ensures successful post-migration testing and production deployment.

## Conclusion

In this blog post, you learned how [Bell Canada](https://www.bell.ca/) leveraged the scalable infrastructure of AWS to complete the technical Unicode conversion of their 11 TB ERP Production system in less than 5 hours and successfully migrated to AWS. This approach resulted in a 75% reduction in technical downtime compared to a single-step Unicode conversion and migration process, which takes more than 24 hours. Additionally, it eliminated the need for additional on-premises hardware resources.

By adopting this approach, [Bell Canada](https://www.bell.ca/) was able to optimize the Unicode conversion and migration process, minimizing business disruption and maximizing operational efficiency. The scalability and flexibility of AWS infrastructure played a crucial role in achieving this remarkable feat, enabling [Bell Canada](https://www.bell.ca/) to complete the complex migration process within a significantly shorter timeframe.

In this blog, we used [Oracle Data Guard](https://www.oracle.com/in/database/data-guard/) to set up the staging instance. However, there are restrictions when changing endianness (Big Endian and Little Endian), such as from AIX (Big Endian) to X86_64 (Little Endian), as per Oracle’s documentation [Data Guard Support for Heterogeneous Primary and Physical Standbys in Same Data Guard Configuration](https://support.oracle.com/knowledge/Oracle Cloud/413484_1.html) (requires an Oracle support login). [SAP Note 552464](https://me.sap.com/notes/552464/E) guides on determining the exact endianness for different architectures and operating systems. In scenarios where customers need to migrate SAP non-Unicode system on Oracle database from a big-endian to a little-endian platform, Oracle Cross-Platform Transportable Tablespaces (XTTS) is utilized to migrate the non-Unicode system to AWS following the blog [Reducing downtime with Oracle XTTS method for cross-platform SAP migrations](https://aws.amazon.com/blogs/awsforsap/reducing-downtime-with-oracle-xtts-method-for-cross-platform-sap-migrations/). Once the non-Unicode system is available on AWS, you can perform the export and import processes on AWS following the steps outlined in this blog.

## Join the SAP on AWS Discussion

In addition to your customer account team and [AWS Support](https://aws.amazon.com/contact-us/) channels, AWS provides public Question & Answer forums on our [re:Post Site](https://aws.amazon.com/blogs/aws/aws-repost-a-reimagined-qa-experience-for-the-aws-community/). Our SAP on AWS Solution Architecture team regularly monitor the [SAP on AWS](https://www.repost.aws/topics/TAujMzs1_ZR3SIaMwia7ln7A/sap-on-aws) topic for discussion and questions that could be answered to assist you. If your question is not support-related, consider joining the discussion over at [re:Post](https://www.repost.aws/topics/TAujMzs1_ZR3SIaMwia7ln7A/sap-on-aws) and adding to the community knowledge base.

## Credits

We would like to thank the following team members for their contributions: Derek Ewell and Spencer Martenson.

<!-- ### About the authors

![Sriram Rajan](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/10/author-sriram-rajan.jpg)  
**Sriram Rajan** is a Principal Specialist Solutions Architect for SAP on AWS. With over 20 years of experience in SAP and cloud technologies, he helps customers architect and migrate SAP workloads to AWS.

![Gokul Rajaram](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/10/author-gokul-rajaram.jpg)  
**Gokul Rajaram** is a Senior Solutions Architect at AWS, specializing in SAP migrations. He assists customers in optimizing downtime and leveraging AWS services for SAP Unicode conversions.

![Vijayakumar Subramanian](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/10/author-vijayakumar-subramanian.jpg)  
**Vijayakumar Subramanian** is a SAP Basis Consultant at Bell Canada, with expertise in Oracle databases and AWS migrations. -->