# Assignment-01: Load Balancer & Auto Scaling Group

## Objective
Design and implement a highly available, scalable, and secure AWS infrastructure for deploying the Spring3Hibernate application.

Repository:
https://github.com/opstree/spring3hibernate.git

---

# Architecture Diagram

> Add your architecture image here.

```md
![Architecture Diagram](images/architecture.png)
```
---

# Infrastructure Components

## VPC
- CIDR: `10.0.0.0/24`
- Provides an isolated network for all AWS resources.

## Availability Zones
- ap-south-1a
- ap-south-1b

Used for High Availability.

## Public Subnets
- 10.0.0.0/26

Resources:
- Application Load Balancer
- NAT Gateway
- Bastion Host

## Private Subnets
- 10.0.0.64/26
- 10.0.0.128/26

Resources:
- Spring3Hibernate EC2 Instances
- Auto Scaling Group

## Internet Gateway
Provides internet access to public resources.

## NAT Gateway
Allows private instances to access the internet for:
- Package updates
- Maven dependencies
- Git operations

![](images/networking.png)

## Application Load Balancer (ALB)
- Receives user traffic
- Distributes requests across application servers
- Improves availability and fault tolerance
     
![](images/Load Balancer.png)

## Target Group
- Contains application instances
- Performs health checks
- Routes traffic only to healthy targets 

![](images/health check.png)

## Auto Scaling Group (ASG)
Automatically:
- Launches new instances during high load
- Removes instances during low load
- Maintains desired capacity

![](images/Auto Scalling Group.png)

## Bastion Host
Secure entry point for administrators to access private instances.

![](images/ssh priavte instance.png)
![](images/first desire instance created.png)

## Security Groups
### ALB Security Group
- Allow HTTP (80)
- Allow HTTPS (443)

![](images/alb-sg.png)

### Application Security Group
- Allow application traffic only from ALB

![](images/app-sg.png)

### Bastion Security Group
- Allow SSH (22) from trusted IPs

![](images/bastion-sg.png)

## Network ACLs
Additional subnet-level security controls.

![](images/private-nacl.png)
![](images/public-nacl.png)
![](images/private-nacl-subnet.png)
![](images/public-nacl-subnet.png)

---

# Traffic Flow

User
→ Internet
→ Internet Gateway
→ Application Load Balancer
→ Target Group
→ Spring3Hibernate Instances

Admin
→ Bastion Host
→ Private EC2 Instances

Private EC2
→ NAT Gateway
→ Internet

---

# High Availability Features

- Multi-AZ Deployment
- Application Load Balancer
- Auto Scaling Group
- Health Checks
- Private Application Servers

---

# Security Features

- Private Application Subnets
- Security Groups
- Network ACLs
- Bastion Host
- Controlled Internet Access through NAT Gateway

---

# Scaling Strategy

Minimum Capacity: 2

Desired Capacity: 2

Maximum Capacity: 5

Scale-Out Trigger:
- CPU Utilization > 70%

Scale-In Trigger:
- CPU Utilization decreases below threshold

![](images/increase load.png)
![](images/after load increase auto scalling starts.png)
![](images/remove load.png)
![](images/cooling download after load decrease.png)

![](images/app runngin with load balancer.png)

---

# Scaling Strategy
Use load template in autoscalling

![](images/Launch Template.png)
![](images/launch template.png)

----


# Expected Outcome

- Highly Available Architecture
- Secure Deployment
- Automatic Scaling
- Fault Tolerance
- Load Distribution Across Multiple Instances
