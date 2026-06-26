# Assignment 5 - Kubernetes Deployment of OT-Microservices

## Objective

The objective of this assignment is to deploy the **OT-Microservices** application on Kubernetes by creating separate pods for each service and validating communication between them.

## Step 1: Attendance Setup

**Option Used**
- MySQL deployed in a separate pod
- Attendance deployed in a separate pod

### Validation

```bash
kubectl get pods
kubectl get svc
```

**Screenshot**
![]('images/kubectl-cmds.png')
---

## Step 2: Backend Services

### Salary Pod

### Employee Pod

## Step 3: Frontend and Webserver

### Frontend Pod

### Webserver Pod

## Verify Deployment

![]('images/kubectl-cmds.png')
![]('images/kubectl-cmds1.png')
![]('images/frontend.png')
![]('images/employee-list.png')
![]('images/salary-list.png')



## Conclusion

Successfully deployed the OT-Microservices application on Kubernetes.

- ✅ Attendance deployed
- ✅ MySQL deployed
- ✅ Elasticsearch deployed
- ✅ Salary connected with Elasticsearch
- ✅ Employee connected with Elasticsearch
- ✅ Frontend deployed
- ✅ Webserver deployed
- ✅ Application accessible in browser
- ✅ All pods and services verified
