This tutorial shows how to deploy a simple house price prediction model.

## How-to Guide

### Start Jenkins service locally
```shell
docker compose -f docker-compose.yaml up -d
```
You can find the password for `admin` at the path `/var/jenkins_home/secrets/initialAdminPassword` in the container Jenkins.

### Push the whole code to Github for automatic deployment
```shell
git add --all
git commit -m "first attempt to deploy the model"
git push origin your_branch
```

## How to connect jekins container to docker hub


## How to build a Jenkins image on Mac M-series chips that can use Podman/Docker independently

1. Podman
1.1. Run this Jenkins Dockerfile
```
# Ref: https://hackmamba.io/blog/2022/04/running-docker-in-a-jenkins-container/
# Jenkins image
FROM jenkins/jenkins:lts

# Set the current user to root
USER root

# Update packages on image and install podman
# Podman is available in Debian 12 (Bookworm) official repositories
RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common \
        podman \
        uidmap && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add jenkins user to podman group so that jenkins can use podman
USER jenkins
```

1.2 Build created Dockerfile
```
version: '3.8'
services:
  jenkins:
    image: myjenkins-arm64
    container_name: jenkins
    restart: unless-stopped
    privileged: true
    user: root
    ports:
      - 8081:8080
      - 50000:50000
    volumes:
      - jenkins_home:/var/jenkins_home

volumes:
  jenkins_home:
```

2. Docker
- Run this Jenkins Dockerfile
```
# Set the base image for the new image
FROM jenkins/jenkins:lts

# Set the current user to root.
# This is necessary bc some of the following commands need root privileges.
USER root

# Update the package list on the image
RUN apt-get update && \
    # Install the packages for adding the Docker repo and installing Docker
    apt-get install -y apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common && \
    # Download the Docker repository key and add it to the system
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    # Add the Docker repository to the system
    add-apt-repository \
        "deb [arch=arm64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable" && \
    # Update the package list again to include the new repository
    apt-get update && \
    # Install the Docker CE package
    apt-get install -y docker-ce && \
    # Add the Jenkins user to the Docker group so the Jenkins user can run Docker commands
    usermod -aG docker jenkins
```

- Build create Dockerfile
```
version: '3.8'
services:
  jenkins:
    image: myjenkins-arm64
    container_name: jenkins
    restart: unless-stopped
    privileged: true
    user: root
    ports:
      - 8081:8080
      - 50000:50000
    volumes:
      - jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock

volumes:
  jenkins_home:
```
