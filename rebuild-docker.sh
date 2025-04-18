#!/bin/bash

# Colors for messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No color

# Image and container names
IMAGE="surfingkeys-conf"
CONTAINER="surfingkeys-container"
DOCKERFILE="DOCKERFILE"
PORT="9919"

echo -e "${YELLOW}Docker rebuild script for $IMAGE${NC}"

# Function to rebuild the image and restart the container
rebuild_docker() {
    echo -e "${YELLOW}Stopping existing container (if running)...${NC}"
    docker stop $CONTAINER 2>/dev/null
    docker rm $CONTAINER 2>/dev/null

    echo -e "${YELLOW}Building new Docker image...${NC}"
    if docker build -t $IMAGE -f $DOCKERFILE .; then
        echo -e "${GREEN}Image built successfully.${NC}"
        
        echo -e "${YELLOW}Starting new container...${NC}"
        if docker run -d -p $PORT:$PORT --restart unless-stopped --name $CONTAINER $IMAGE; then
            echo -e "${GREEN}Container started successfully.${NC}"
            echo -e "${GREEN}The application is available at http://localhost:$PORT${NC}"
        else
            echo -e "${RED}Error starting the container.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Error building the Docker image.${NC}"
        exit 1
    fi
}

# Run the rebuild process
rebuild_docker
