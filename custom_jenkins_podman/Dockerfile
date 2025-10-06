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
        git \
        podman \
        uidmap && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add jenkins user to podman group so that jenkins can use podman
USER jenkins