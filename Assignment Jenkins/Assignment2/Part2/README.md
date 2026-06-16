# Jenkins Assignment-02 (Part 2)
## Google SSO Integration for Admin User

### Objective
Enable Google Single Sign-On (SSO) for Jenkins administrator access.

---

## Prerequisites

### Jenkins Plugin
Install:
- Google Login Plugin

---

## Create Google OAuth Credentials

1. Open Google Cloud Console
2. Create a new project
3. Navigate to APIs & Services → Credentials
4. Create OAuth Client ID
5. Select Web Application

### Authorized Redirect URI

```text
http://<jenkins-host>:8080/securityRealm/finishLogin
```

Example:

```text
http://localhost:8080/securityRealm/finishLogin
```

Save and copy:
- Client ID
- Client Secret

---

## Configure Jenkins

Navigate to:

Manage Jenkins → Configure Global Security

### Security Realm

Select:

```text
Google Login
```

Enter:
- Client ID
- Client Secret

Save configuration.

---

## Role Assignment

After successful Google login:

1. Open Manage Users
2. Identify Google user account
3. Navigate to Manage and Assign Roles
4. Assign Admin role

Example:

| User | Role |
|------|------|
| admin@gmail.com | admin |

---
![]('images/sso.png')

![]('images/google sso dashboard.png')

