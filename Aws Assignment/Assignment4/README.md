# Assignment 04 – Infrastructure Provisioning Using Terraform

## Objective

The objective of this assignment is to design and implement cloud infrastructure using **Terraform Infrastructure as Code (IaC)** based on a predefined architecture. The infrastructure follows Terraform best practices and uses **Amazon S3** for remote state management.

---

# Architecture Overview

The infrastructure consists of the following AWS resources:

- VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- Route Tables
- Security Groups
- Jump Server (Bastion Host)
- Private EC2 Server
- Launch Template
- Auto Scaling Group (ASG)
- Application Load Balancer (ALB)
- OpenSearch Cluster
- OpenSearch Dashboard
- S3 Bucket for Terraform Backend

---

# Architecture Diagram

![](images/assignment.png)

---

# Infrastructure Components

## Networking Layer

- VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- Route Tables

![](images/Vpc-and-resource-map.png)

## Security Layer

- Jump Server Security Group
- Application Security Group

![](images/jump-server-with-SG.png)
![](images/private-server-with-SG.png)


## Compute Layer

### Jump Server (Bastion Host)

- Public IP
- SSH Access using PEM Key

![](images/jump-server-with-pem-key-with-public-ip.png)

### Private EC2 Server

- No Public IP
- Accessible through Bastion Host

![](images/private-server-create-through-asg.png)

## Load Balancer Layer

### Application Load Balancer (ALB)

- Traffic Distribution
- Health Checks
- Target Groups

![](images/Load-Balancer.png)

## Auto Scaling

### Launch Template

Defines:
- AMI
- Instance Type
- Security Groups
- User Data

![](images/Launch-template.png)

### Auto Scaling Group

- Automatic Scaling
- High Availability
- Integrated with ALB

![](images/asg.png)
![](images/instances-through-asg.png)


## OpenSearch Deployment

- OpenSearch Domain

![](images/openseach-data.png)
![](images/target-group-for-opensearch-dashboard.png)

- OpenSearch Dashboard

![](images/opensearch-dashboard.png)
![](images/target-group-for-opensearch.png)


---

# Terraform Backend Configuration

## S3 Backend

Used for storing Terraform State remotely.
![](images/created-bucket-for-tarraform.tfstate.png)
![](images/store-tfstate-file-on-s3-backend.png.png)
![](images/store-tfstate-file-on-s3-backend.png.png)


---

# Terraform

![](images/terraform-apply1.png)
![](images/terraform-apply2.png)


# Outcome

Successfully provisioned AWS infrastructure using Terraform including networking, compute resources, load balancing, auto scaling, OpenSearch, and remote state management with S3 and DynamoDB.
