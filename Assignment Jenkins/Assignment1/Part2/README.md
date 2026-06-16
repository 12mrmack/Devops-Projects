# Jenkins Assignment - Part 2

## Objective

Create two Jenkins Freestyle jobs:

1.  Job 1 accepts a parameter `<Ninja Name>` and creates a file
    containing: `<Ninja Name> from DevOps Ninja`
2.  Job 2 publishes the file using a web server.
3.  Job 2 must trigger automatically after Job 1 completes successfully.
4.  Slack and Email notifications must be sent on Success and Failure.

------------------------------------------------------------------------

## Job 1: create-ninja-file

### Features

-   Parameterized build
-   Creates file dynamically
-   Automatically triggers Job 2

### Parameter

    NINJA_NAME

### Build Step (Execute Shell)

``` bash
mkdir -p /tmp/ninja
echo "${NINJA_NAME} from DevOps Ninja" > /tmp/ninja/ninja.txt
cat /tmp/ninja/ninja.txt
```

### Post Build Action

-   Build other projects → `publish-ninja-file`
-   Trigger only if build is stable

------------------------------------------------------------------------

## Job 2: publish-ninja-file

### Features

-   Installs Apache Web Server
-   Publishes file content as webpage

### Build Step (Execute Shell)

``` bash
sudo apt update
sudo apt install apache2 -y
sudo cp /tmp/ninja/ninja.txt /var/www/html/index.html
sudo systemctl restart apache2
```

------------------------------------------------------------------------

## Automation Flow

    Job 1 → Success → Job 2 → Notifications

------------------------------------------------------------------------

## Notifications

### Slack Notification

Configured from:

    Manage Jenkins → Configure System → Slack

### Email Notification

Configured from:

    Manage Jenkins → Configure System → Email Notification

Triggers: - Success - Failure

------------------------------------------------------------------------

## Verification

Open browser:

    http://<Jenkins_Server_IP>
    
    ![](images/3.png)

Expected Output:

    <Ninja Name> from DevOps Ninja

------------------------------------------------------------------------

## all screenshot

![](images/1.png)

![](images/2.png)

![](images/4.png)

![](images/5.png)

![](images/6.png)


