
# 🚀 Essential Commands for Container Management using Docker

A comprehensive list of **must-know Docker commands** for managing containers — from creation to troubleshooting.

---

## 🧱 Create & Run Containers
```sh
1. **Create a Container**
    docker create --name my_container ubuntu
    Creates a container from an Ubuntu image but doesn’t start it.

2. Run a Container Interactively
    docker run -it ubuntu
    Runs a new container interactively with a terminal session (-it).

3. Run in Detached Mode
    docker run -d --name my_container nginx
    Starts a container in the background (detached mode) using Nginx image.

4. Run a Container with a Custom Name and Port
    docker run -d -p 8080:80 --name web_server nginx
    Runs an Nginx container accessible at http://localhost:8080.

5. Run and Automatically Remove After Exit
    docker run --rm -it ubuntu
    Removes the container automatically after it stops.

6. Run with Volume Mount
    docker run -d -v /host/data:/container/data ubuntu
    Mounts a host directory into the container (useful for persistence).

```

## ⚙️ Manage Containers

```sh

1. List Running Containers
   docker ps
   Shows only active containers.

2. List All Containers (Including Stopped)
   docker ps -a
   Displays all containers.

3. Stop a Running Container
   docker stop my_container
   Gracefully stops a running container.

4. Start a Stopped Container
   docker start my_container
   Restarts an existing stopped container.

5. Restart a Container
   docker restart my_container
   Stops and starts the container again.

6. Pause and Unpause a Container
   docker pause my_container
   docker unpause my_container
   Temporarily suspends/resumes all processes in a container.

7. Remove a Stopped Container
   docker rm my_container
   Deletes a stopped container.

8. Force Remove All Containers
   docker rm -f $(docker ps -aq)
   Removes all containers (running and stopped).

```
## 🌐 Expose Applications to the World 

```sh

1. Expose a Specific Port
   docker run -d -p 8080:80 nginx
   Maps port 8080 on the host to port 80 in the container.

2. Expose Random Ports Automatically
   docker run -d -P nginx
   Automatically maps available host ports to container ports.

3. Run with Environment Variables
   docker run -d -e "APP_MODE=production" my_app
   Passes environment variables to the container.

4. Run with Multiple Environment Variables from File
   docker run --env-file .env -d my_app
   Loads environment variables from a .env file.

```

## 💻 Interact with Containers (exec & attach)

```sh

1. Execute Commands Inside a Running Container
   docker exec -it my_container bash
   Starts an interactive bash shell inside a running container.

2. Run a Single Command Inside a Container
   docker exec my_container ls /app
   Executes a one-time command inside the container.

3. Attach to a Running Container
   docker attach my_container
   Connects directly to a container’s terminal (detach with Ctrl + P + Q).

```

## 📁 Copying Files Between Host and Container

```sh

1. Copy from Host → Container
   docker cp my_file.txt my_container:/tmp/

2. Copy from Container → Host
   docker cp my_container:/tmp/my_file.txt ./
 
```

## 🔍 Inspect, Monitor & Troubleshoot

```sh

1. Inspect Container Metadata
   docker inspect my_container
   Displays detailed container info (network, volumes, env, etc).

2. View Container Logs
   docker logs my_container
   Shows logs from a container (use -f to follow logs in real-time).

3. Monitor Resource Usage
   docker stats
   Shows live CPU, memory, and network usage.

4. View Running Processes in a Container
   docker top my_container
   Lists active processes inside the container.

5. Check Container Port Mappings
   docker port my_container
   Displays container’s exposed ports and their host mappings.

```
## 🧹 Cleanup Commands

```sh

1. Remove All Stopped Containers
   docker container prune

2. Remove Unused Images
   docker image prune

3. Remove Unused Volumes
 docker volume prune

4. Remove Everything (Warning: Irreversible)
   docker system prune -a
   Deletes all stopped containers, unused networks, images, and cache.

```
