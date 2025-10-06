#!/bin/bash
# Start Docker daemon in background
dockerd &

# Wait for Docker to be ready
timeout=30
while ! docker info >/dev/null 2>&1; do
    timeout=$((timeout-1))
    if [ $timeout -le 0 ]; then
        echo "Docker daemon failed to start"
        exit 1
    fi
    echo "Waiting for Docker daemon to start..."
    sleep 1
done

echo "Docker daemon is running"

# Start Jenkins (use original entrypoint)
exec /usr/local/bin/jenkins.sh "$@"

