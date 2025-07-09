# AWS DISASTER RECOVERY MULTI TIER ARCHITECTURE USING TERRAFORM
## This guide outlines the step-by-step deployment of a scalable and secure multi-tier architecture on AWS using Terraform. This approach leverages Infrastructure as Code to automate cloud infrastructure provisioning and minimize manual errors.The code is deployed in two different regions to maintain disaster recovery constraint.

<img src="https://github.com/user-attachments/assets/7cf1f428-c944-4fbb-8d03-7f3eef570b97" width="500"/>



✅ Core AWS Services Used
Amazon EC2 (Elastic Compute Cloud) for running the application instances using launch templates.

1.Amazon VPC (Virtual Private Cloud)

                To isolate network infrastructure with CIDR-based subnetting.
2.Subnets

                Public and private subnets for routing and tier separation.
3.Internet Gateway
 
                To allow internet access to instances in public subnets.
4.Route Tables

                For managing traffic routing within the VPC.
5.Application Load Balancer (ALB)

                For distributing HTTP traffic to backend instances.
6.Auto Scaling Group (ASG)

               For managing the number of EC2 instances dynamically based on traffic/load.
7.Launch Template

                Predefined configuration to consistently launch EC2 instances.
8.Security Groups

                Virtual firewalls to control inbound and outbound traffic to resources
9.Amazon EC2 (Elastic Compute Cloud)

                 For running the application instances using launch templates.
10. Route 53
    
                    providing dns to the deployed web app and used to achive disater recovery by failover routing schema  
11.Terraform

                  For provisioning, managing, and automating the entire AWS infrastructure
## Step 1: Selecting the AWS Region

The AWS region is the geographical location where your resources are hosted. A well-chosen region ensures low latency, regulatory compliance, and service availability.
Deployed In: us-east-1 (Northern Virginia) # as primary region for D.R
Deployed In: ap-south-1 (Mumbai) # backup region 

## Step 2: Creating the Virtual Private Cloud
 VPC is set up as the isolated networking layer for all AWS resources.
VPC Configuration:
CIDR: 10.0.0.0/16
Features: DNS support and DNS hostnames enabled
This isolated network enables full control over networking and security.
provider

     "aws" {

                    region="us-east-1"  
     }
## Step 3: Designing Subnets for Tiered Architecture
The VPC is divided into two availability zones & each subnet in each AZ to main high availability 

**`Public Subnets(for load balancer and jump boxes):`**

AZ-a: 10.0.1.0/24

AZ-b: 10.0.2.0/24

**`Private Subnets (for backend and database tiers):`**

AZ-a: 10.0.3.0/24, 10.0.5.0/24

AZ-b: 10.0.4.0/24, 10.0.6.0/24

## Step 4: Configuring Internet Access
An Internet Gateway is created and linked to the VPC for outbound internet access from public subnets.

Routing Setup:

Public route table has IGW route and associate public subnets to make it access to internet.
Private subnets have internal routing only

Optional: Introduce NAT Gateway for private subnet internet access. In this case we are not using any.
## Step 5: Load Balancer Implementation

An ALB is deployed to handle HTTP traffic and direct it to backend servers hosted in private subnets.

ALB Setup:
Listens on HTTP port 80
Registers instances via target group(create a target group as "INSTANCE RESOURCE")

Exposes DNS for frontend users

## Step 6: Setting up Auto Scaling Group
ASG ensures continuous availability by automatically launching or terminating instances based on health checks.

Configuration:

Launch template specifies AMI, instance type, user data
Health checks determine instance replacement
Integrated with target group of ALB

         health_check_type = "EC2"

     tag {
    key                 = "Name"
    value               = "web-asg-instance"
    propagate_at_launch = true
    }
  
    lifecycle {
      create_before_destroy = true
    }
use create _before_destroy lifecycle to maintain instances up&running before any previous instance delete accidentally.      


## Step 7: Launch Template and Bootstrapping

Launch template includes a shell script that configures the EC2 instance on boot.
Use script.sh file to load user data
    
      user_data = filebase64("script.sh")
## Step 8: Configure Route 53.
In this step, create a public hosted zone in Route 53, and update the name servers
> If the domain is purchased from route 53, then create only hosted zone as name server update itself
> If the domain is purchased from other website, update the hosted zone name servers in other website ans wait 5min-30min
After that, create a A record and select the routing policy as failover
  a. choose primary as one region and 
  b. secondary as another region and
map your respective ALB to their regions domain url. This is alias record.
Now access your domain http://sub-domainname.domainname
## Step 9: Terraform Project Structure

Terraform scripts are organized for clarity and modularization.

1. Key Files:

        main.tf: Resource composition

2.vpc.tf: Network resources

    alb.tf: Load balancer and listeners

3.asg.tf: Auto Scaling configuration

    launch_template.tf: Instance launch template

4. variables.tf: Input definitions

        outputs.tf: Resulting outputs (e.g., ALB DNS)
5. securtiygroups.tf: Define the sg rule to each services 

       securtiygroups.tf HTTP traffic flow

5.provider.tf: AWS region and authentication

## Final Notes

Security: Least privilege principles applied using security groups

Scalability: ASG adjusts to traffic demands

Automation: Complete provisioning via Terraform enhances DevOps practices


## Summary

This project demonstrates a production-ready in AWS environment built entirely through Terraform. The architecture provides flexibility, automation, and resilience suitable for modern application workloads.
