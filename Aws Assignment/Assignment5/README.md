# Assignment 05 - Implement Infrastructure with Terraform Modules

## Objective
Implement AWS infrastructure using reusable Terraform modules and configure remote state management with Amazon S3 and DynamoDB state locking.


## Terraform State Management

- Remote State: Amazon S3
- State Locking: DynamoDB
- Versioning enabled on S3 bucket
- Prevents concurrent Terraform execution

---

## Architecture Screenshots

### VPC Map
![VPC Map](images/vpc%20map.png)

### EC2 Instance
![Instance](images/instance.png)

### Load Balancer
![Load Balancer](images/load%20balancer.png)

### Auto Scaling Group
![ASG](images/asg.png)

### S3 Bucket
![S3 Bucket](images/s3%20bucket.png)

### Terraform State File Stored in S3
![Terraform State](images/store%20state%20file%20on%20bucket.png)

### OpenSearch Dashboard
![OpenSearch Dashboard](images/openseach%20dashboard%20working.png)

### OpenSearch API
![OpenSearch API](images/opensearch%20api%20working.png)

### Backend Lock Configuration
![Lock Backend](images/lock%20backend.png)

### Application Deployment
![Application 1](images/apply1.png)

![Application 2](images/apply2.png)

### Application Health Check
![App Health Check](images/app%20health%20check.png)

### Dashboard Health Check
![Dashboard Health Check](images/app%20dashboard%20health%20check.png)

---

## Deployment Commands

```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

---

## Deliverables

- Reusable Terraform Modules
- VPC, Subnets, Security Groups, EC2, ALB, ASG
- OpenSearch Deployment
- S3 Remote Backend
- DynamoDB State Locking
- Screenshots for verification
