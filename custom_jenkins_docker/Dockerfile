# Set the base image for the new image
FROM jenkins/jenkins:lts

# Set the current user to root.
# This is necessary bc some of the following commands need root privileges.
USER root

# Update the package list and install dependencies
RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        git && \
    # Add Docker's official GPG key (proper way)
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    # Add the repository to Apt sources
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    # Install Docker CE
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    # Add Jenkins user to Docker group
    usermod -aG docker jenkins && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy custom entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set custom entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]