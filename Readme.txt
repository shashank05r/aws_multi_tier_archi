AWS 3-Tier Architecture with Terraform (Version 2 - Further Paraphrased and Expanded)

Purpose

This guide outlines the step-by-step deployment of a scalable and secure 3-tier architecture on AWS using Terraform. This approach leverages Infrastructure as Code to automate cloud infrastructure provisioning and minimize manual errors.

Step 1: Selecting the AWS Region

The AWS region is the geographical location where your resources are hosted. A well-chosen region ensures low latency, regulatory compliance, and service availability.

Deployed In: us-east-1 (Northern Virginia)

Step 2: Creating the Virtual Private Cloud

A VPC is set up as the isolated networking layer for all AWS resources.

VPC Configuration:

CIDR: 10.0.0.0/16

Features: DNS support and DNS hostnames enabled

This isolated network enables full control over networking and security.

Step 3: Designing Subnets for Tiered Architecture

The VPC is divided into multiple subnets to segregate traffic and services.

Public Subnets (for load balancer and jump boxes):

AZ-a: 10.0.1.0/24

AZ-b: 10.0.2.0/24

Private Subnets (for backend and database tiers):

AZ-a: 10.0.3.0/24, 10.0.5.0/24

AZ-b: 10.0.4.0/24, 10.0.6.0/24

Step 4: Configuring Internet Access

An Internet Gateway is created and linked to the VPC for outbound internet access from public subnets.

Routing Setup:

Public route table has IGW route

Private subnets have internal routing only

Optional: Introduce NAT Gateway for private subnet internet access.

Step 5: Load Balancer Implementation

An ALB is deployed to handle HTTP traffic and direct it to backend servers hosted in private subnets.

ALB Setup:

Listens on HTTP port 80

Registers instances via target group

Exposes DNS for frontend users

Step 6: Setting up Auto Scaling Group

ASG ensures continuous availability by automatically launching or terminating instances.

Configuration:

Launch template specifies AMI, instance type, user data

Health checks determine instance replacement

Integrated with target group of ALB

Step 7: Launch Template and Bootstrapping

Launch template includes a shell script that configures the EC2 instance on boot.

Example Script:

#!/bin/bash
dnf update -y
dnf install -y httpd
echo "<html><h2>Deployed via Terraform ASG!</h2></html>" > /var/www/html/index.html
systemctl enable httpd
systemctl start httpd

Step 8: Terraform Project Structure

Terraform scripts are organized for clarity and modularization.

Key Files:

main.tf: Resource composition

vpc.tf: Network resources

alb.tf: Load balancer and listeners

asg.tf: Auto Scaling configuration

launch_template.tf: Instance launch template

variables.tf: Input definitions

outputs.tf: Resulting outputs (e.g., ALB DNS)

provider.tf: AWS region and authentication

Final Notes

Security: Least privilege principles applied using security groups

Scalability: ASG adjusts to traffic demands

Automation: Complete provisioning via Terraform enhances DevOps practices

Extensions: Add RDS MySQL/Aurora, NAT Gateway, Bastion host, and monitoring

Summary

This project demonstrates a production-ready 3-tier AWS environment built entirely through Terraform. The architecture provides flexibility, automation, and resilience suitable for modern application workloads.

