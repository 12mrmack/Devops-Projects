# 🚀 Ansible Assignment 2

**Nginx + Apache Reverse Proxy \| Website Rotation \| Rolling Updates**

------------------------------------------------------------------------

## 📌 Project Description

This project demonstrates automation using **Ansible Ad-hoc commands**.

Features implemented:

-   Install Nginx on multiple worker nodes
-   Restrict Nginx log files to maximum 1GB
-   Install Apache backend server
-   Configure Nginx as Reverse Proxy to Apache
-   Host multiple team member websites
-   Automatically rotate websites every 2 hours
-   Perform rolling updates (one node at a time)
-   Use different Ansible execution strategies

------------------------------------------------------------------------

## 🏗️ Architecture

User → team.opstree.com → Nginx (Port 80) → Apache (Port 8080) → Website

------------------------------------------------------------------------

## 🖥️ Infrastructure

  Component      Details
  -------------- ---------------------------------
  Control Node   Laptop with Ansible Installed
  Worker Nodes   Multiple AWS EC2 Ubuntu Servers
  Automation     Ansible Ad-hoc Commands

------------------------------------------------------------------------

## ⚙️ Inventory Example

``` ini
[workers]
node1 ansible_host=<IP1>
node2 ansible_host=<IP2>
node3 ansible_host=<IP3>

[workers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/key.pem
```

------------------------------------------------------------------------

## ✅ Step 1 --- Install Nginx

Install nginx:

``` bash
ansible workers -i inventory -b -m apt -a "name=nginx state=present update_cache=yes"
```

Start nginx:

``` bash
ansible workers -b -m service -a "name=nginx state=started enabled=yes"
```

------------------------------------------------------------------------

## ✅ Step 2 --- Limit Nginx Log Size (1GB)

Configure logrotate:

``` bash
ansible workers -b -m copy -a "dest=/etc/logrotate.d/nginx content='
/var/log/nginx/*.log {
 size 1G
 rotate 7
 compress
 missingok
 notifempty
}
'"
```

------------------------------------------------------------------------

## ✅ Step 3 --- Install Apache

``` bash
ansible workers -b -m apt -a "name=apache2 state=present"
```

Start Apache:

``` bash
ansible workers -b -m service -a "name=apache2 state=started enabled=yes"
```

------------------------------------------------------------------------

## ✅ Step 4 --- Move Apache to Port 8080

Change port:

``` bash
ansible workers -b -m replace -a "path=/etc/apache2/ports.conf regexp='Listen 80' replace='Listen 8080'"
```

Update VirtualHost:

``` bash
ansible workers -b -m replace -a "path=/etc/apache2/sites-available/000-default.conf regexp='<VirtualHost *:80>' replace='<VirtualHost *:8080>'"
```

Restart Apache:

``` bash
ansible workers -b -m service -a "name=apache2 state=restarted"
```

------------------------------------------------------------------------

## ✅ Step 5 --- Create Websites

Create directories:

``` bash
ansible workers -b -m file -a "path=/var/www/tanya state=directory"
ansible workers -b -m file -a "path=/var/www/heena state=directory"
```

Create webpages:

``` bash
ansible workers -b -m copy -a "dest=/var/www/tanya/index.html content='<h1>Tanya Website</h1>'"
ansible workers -b -m copy -a "dest=/var/www/heena/index.html content='<h1>Heena Website</h1>'"
```

------------------------------------------------------------------------

## ✅ Step 6 --- Configure Apache Backend

Create backend config:

``` bash
ansible workers -b -m copy -a "dest=/etc/apache2/sites-available/backend.conf content='
<VirtualHost *:8080>
 DocumentRoot /var/www/tanya
 <Directory /var/www/tanya>
   Require all granted
 </Directory>
</VirtualHost>
'"
```

Enable site:

``` bash
ansible workers -b -m command -a "a2ensite backend.conf"
ansible workers -b -m command -a "a2dissite 000-default.conf"
```

Restart Apache:

``` bash
ansible workers -b -m service -a "name=apache2 state=restarted"
```

------------------------------------------------------------------------

## ✅ Step 7 --- Configure Nginx Reverse Proxy

Create reverse proxy config:

``` bash
ansible workers -b -m copy -a "dest=/etc/nginx/sites-available/reverse.conf content='
server {
 listen 80;
 location / {
   proxy_pass http://127.0.0.1:8080;
 }
}
'"
```

Enable configuration:

``` bash
ansible workers -b -m file -a "path=/etc/nginx/sites-enabled/default state=absent"
ansible workers -b -m command -a "ln -sf /etc/nginx/sites-available/reverse.conf /etc/nginx/sites-enabled/reverse.conf"
```

Restart nginx:

``` bash
ansible workers -b -m service -a "name=nginx state=restarted"
```

------------------------------------------------------------------------

## ✅ Step 8 --- Website Rotation Every 2 Hours

Create switch script:

``` bash
ansible workers -b -m copy -a "dest=/usr/local/bin/site-switch.sh mode=0755 content='
#!/bin/bash
FLAG=/tmp/site_flag

if [ ! -f $FLAG ]; then
  cp -r /var/www/heena/* /var/www/tanya/
  touch $FLAG
else
  cp -r /var/www/tanya/* /var/www/heena/
  rm -f $FLAG
fi

systemctl reload apache2
'"
```

Add cron job:

``` bash
ansible workers -b -m cron -a "name='Website Switch' minute=0 hour='*/2' job='/usr/local/bin/site-switch.sh'"
```

------------------------------------------------------------------------

## ✅ Step 9 --- Rolling Updates

Update nodes one by one:

``` bash
ansible workers -f 1 -b -m service -a "name=nginx state=restarted"
```

------------------------------------------------------------------------

## 📸 Screenshots

![](images/1.png)

after 1minutes

![](images/2.png)

------------------------------------------------------------------------

## 🎯 Concepts Learned

-   Ansible Ad-hoc Commands
-   Reverse Proxy Architecture
-   Log Management
-   Cron Automation
-   Rolling Deployment
-   Production DevOps Workflow

------------------------------------------------------------------------

## 👨‍💻 Author

**Maqbool Alam**
