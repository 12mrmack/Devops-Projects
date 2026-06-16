# Jenkins Assignment 1 — Part 1

## Git Operations Automation using Jenkins Freestyle Job

---

## 📌 Project Overview

This project demonstrates automation of common Git operations using **Jenkins Freestyle Job**.

The Jenkins job performs multiple Git lifecycle tasks automatically and sends notifications via Slack and Email based on build status.

---

## 🛠 Tool Used

* Jenkins (Freestyle Job)
* Git
* Slack Notification Plugin
* Email Extension Plugin
* Linux Shell Scripting

---

## 🎯 Objective

Create a Jenkins job capable of performing:

* Create a branch
* List all branches
* Merge one branch with another
* Rebase one branch with another
* Delete a branch

Additionally:

* Send Slack notification on Success or Failure
* Send Email notification on Success or Failure

---

## ⚙️ Jenkins Job Configuration

### 1️⃣ Create Freestyle Job

```
New Item → Freestyle Project
Name: git-operations-job
```

---

### 2️⃣ Source Code Management

Configure Git repository:

```
Repository URL: https://github.com/<username>/<repository>.git
Branch: main
```

---

### 3️⃣ Build Step

Add:

```
Build → Execute Shell
```

Script used:

```bash
echo "===== AUTHENTICATING ====="

git remote set-url origin https://$GIT_USERNAME:$GIT_TOKEN@github.com/12mrmack/jenkins.git

git config user.name "12mrmack"
git config user.email "12mrmack@gmail.com"


echo "===== CLEAN OLD BRANCH ====="
git branch -D feature2 || true
git push origin --delete feature2 || true

echo "===== CREATE BRANCH ====="
git checkout -b feature2
git push -u origin feature2

echo "===== LIST BRANCH ====="
git branch -a

echo "===== MERGE ====="
git checkout main 2>/dev/null || git checkout master
git merge feature2
git push origin main || git push origin master

echo "===== REBASE ====="
git checkout feature2
git rebase main 2>/dev/null || git rebase master

echo "===== DELETE ====="
git checkout main 2>/dev/null || git checkout master
git branch -D feature2
git push origin --delete feature2 || true
```

---

## 🔔 Notification Configuration

### Slack Notification

Configured in:

```
Manage Jenkins → Configure System → Slack
```

Enabled:

* Notify Success
* Notify Failure

---

### Email Notification

Configured using:

```
Editable Email Notification Plugin
```

Triggers enabled:

* Success
* Failure

---

## 🔄 Workflow

```
Jenkins Job Start
        ↓
Clone Repository
        ↓
Git Operations Executed
        ↓
Build Status Generated
        ↓
Slack Notification Sent
        ↓
Email Notification Sent
```

---

## ✅ Expected Output

Jenkins console will show:

* Branch creation
* Branch listing
* Successful merge
* Successful rebase
* Branch deletion

---

## 📸 Screenshots Included

* Console Output
![](images/1.png)
* Slack Notification Message
![](images/2.png)
* Email Notification Message
![](images/3.png)

---

## 🚀 How to Run

1. Open Jenkins Dashboard
2. Select `git-operations-job`
3. Click **Build Now**
4. Monitor Console Output

---

