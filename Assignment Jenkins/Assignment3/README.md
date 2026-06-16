# Assignment - 03: Continuous Integration Checks using Jenkins

## Objective

Implement Continuous Integration (CI) checks for multiple application repositories using Jenkins Freestyle Jobs. The setup includes source code checkout, static code analysis, secret scanning, dependency vulnerability scanning, unit testing, code coverage reporting, artifact management, and failure notifications.

---

## Repositories Used

### Python API
Repository: https://github.com/OT-MICROSERVICES/attendance-api

### GoLang API
Repository: https://github.com/OT-MICROSERVICES/employee-api

### Java API
Repository: https://github.com/opstree/spring3hibernate.git

---

## Jenkins Environment

| Component | Version |
|------------|----------|
| Jenkins | Latest LTS |
| Java | JDK 17 |
| Python | Python 3.x |
| Go | Go 1.x |
| Maven | Maven 3.x |
| Ubuntu | Ubuntu 24.04 |

---

## Jenkins Plugins Used

- Git Plugin
- HTML Publisher Plugin
- JUnit Plugin
- Email Extension Plugin
- Slack Notification Plugin
- Warnings NG Plugin
- OWASP Dependency Check Plugin
- JaCoCo Plugin
- SonarQube Scanner Plugin

---

## Jenkins Job Structure

1. attendance-api-ci

![]('images/attendance api 2.png')
![]('images/attendance api 1.png')

2. employee-api-ci

![]('images/employee api 2.png')
![]('images/employee api 1.png')

3. spring3hibernate-ci

![]('images/sprint3hibernate api 2.png')
![]('images/sprint3hibernate api 1.png')

---

## CI Checks Implemented

- Source Code Checkout
- Secret Scanning
- Dependency Vulnerability Scanning
- Static Code Analysis
- Unit Testing
- Code Coverage Reporting
- Artifact Archiving
- Failure Notifications

---

## Artifact Management

Artifacts archived:
- Coverage Reports
- Test Reports
- Build Outputs
- Dependency Scan Reports

---

## Notification Configuration

### Email Notifications
- Build Failure
- Unstable Build

![]('images/email.png')

### Slack Notifications
- Success
- Failure
![]('images/slack.png')

---

