# Docker Assignment 2 - Docker Web Server

## Objective
Create a Docker image using Ubuntu latest, install NodeJS, NPM, and http-server, then host a simple HTML webpage on port 8080.

## Project Structure

```text
Assignment2/
├── Dockerfile
├── index.html
└── README.md
```

## Step 1: Create index.html

## Step 2: Create Dockerfile

## Step 3: Build Docker Image

```bash
docker build -t maqbool:docker-app .
```

Verify:

```bash
docker images
```

---

## Step 4: Run Container

```bash
docker run -d --name docker-app-container -p 8081:8080 maqbool:docker-app
```

Verify:

```bash
docker ps
```

---

## Step 5: Access Website


```text
http://192.168.1.6:8081/index.html
```
![](images/index.png)

## Step 6: Stop and Remove Container

```bash
docker stop docker-web-container
docker rm docker-web-container
```

---

## Step 7: Remove Docker Image

```bash
docker rmi maqbool:docker-web
```

---

## Assignment Outcome

- Ubuntu latest image used
- Maintainer label added
- NodeJS installed
- NPM installed
- Symlink created
- http-server installed globally
- HTML page copied into container
- Website served on port 8081
- Custom Docker image created
- Container successfully deployed and removed

---

