# Jenkins Assignment-02 (Part 1)
## User Authentication and Authorization using Role-Based Access Control (RBAC)

### Objective
Implement Jenkins security using Role-Based Authorization Strategy for three teams:
- Developer
- Testing
- DevOps

### Users

#### Developers
- developer-1
- developer-2

#### Testing
- testing-1
- testing-2

#### DevOps
- devops-1
- devops-2

#### Administration
- admin-1

![]('images/Users.png')

---

## Required Plugins
- Role-based Authorization Strategy
- Matrix Authorization Strategy
- Folders Plugin (Optional)

---

## Create Jenkins Jobs

### Developer Jobs
- dev-1
- dev-2
- dev-3

### Testing Jobs
- test-1
- test-2
- test-3

### DevOps Jobs
- devops-1
- devops-2
- devops-3

### Build Step

```bash
echo "Job Name: $JOB_NAME"
echo "Build Number: $BUILD_NUMBER"
```

![]('images/jobs.png')

---

## Create Views

### Developer View
Pattern:
```
dev-*
```

### Testing View
Pattern:
```
test-*
```

### DevOps View
Pattern:
```
devops-*
```

![]('images/ Devops Login dashboard.png')

---

## Configure Security

### Authentication
Manage Jenkins → Security → Jenkins Own User Database

### Authorization
Manage Jenkins → Security → Role-Based Strategy

![]('images/Authenticate & Authrize.png')

---

## Create Roles

### Global Roles
- admin
- developer-view
- testing-view
- devops-view

### Item Roles

#### developer-role
Pattern:
```
dev-.*
```

Permissions:
- Job Read
- Build
- Configure
- Workspace

#### testing-role
Pattern:
```
(test-.*)|(dev-.*)
```

Permissions:
- Job Read
- Build
- Configure
- Workspace

#### devops-role
Pattern:
```
(devops-.*)|(dev-.*)|(test-.*)
```

Permissions:
- Job Read
- Build
- Configure
- Workspace

#### admin-role
Pattern:
```
.*
```

Permissions:
- All

---

## Assign Roles

### Global Roles

| User | Role |
|------|------|
| admin-1 | admin |
| developer-1 | developer-view |
| developer-2 | developer-view |
| testing-1 | testing-view |
| testing-2 | testing-view |
| devops-1 | devops-view |
| devops-2 | devops-view |

### Item Roles

| User | Role |
|------|------|
| developer-1 | developer-role |
| developer-2 | developer-role |
| testing-1 | testing-role |
| testing-2 | testing-role |
| devops-1 | devops-role |
| devops-2 | devops-role |
| admin-1 | admin-role |

![]('images/Manage Roles.png')
![]('images/Assign Roles.png')

---

## Expected Result

### Developer
- Can view only Developer jobs
- Can build jobs
- Can configure jobs
- Can access workspace

### Testing
- Can manage Testing jobs
- Can view Developer jobs

### DevOps
- Can manage DevOps jobs
- Can view Developer and Testing jobs

### Admin
- Full Jenkins access

![]('images/developers Login dashboard.png')
![]('images/ Devops Login dashboard.png')
![]('images/Testing Login Dashboard.png')
---

## Authorization Strategies Overview

### Legacy Mode
Everyone gets administrator access.

### Project-Based Matrix
Permissions configured per job.

### Matrix-Based Security
Permissions assigned globally per user/group.

### Role-Based Authorization
Enterprise-friendly and scalable RBAC implementation.
