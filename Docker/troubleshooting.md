# 🧩 Common Docker Issues, Errors & Troubleshooting Guide

Here’s a complete list of **common Docker problems**, their **causes**, and **solutions** to help you debug faster and keep your environment clean and functional.

---

## 🐳 1. **Container Exits Immediately After Starting**

**🧠 Cause:**
The container’s main process has completed or no foreground process is running.

**✅ Solution:**
- Use an interactive terminal:
  ```sh
  docker run -it ubuntu bash
Or keep the container alive with:

sh
Copy code
docker run -d ubuntu tail -f /dev/null
Check container logs:

sh
Copy code
docker logs <container_name>
🌐 2. Port Not Accessible / Connection Refused
🧠 Cause:
The container’s port is not exposed properly or the host firewall blocks it.

✅ Solution:

Ensure you’ve published ports:

sh
Copy code
docker run -d -p 8080:80 nginx
Check mapped ports:

sh
Copy code
docker port <container_name>
On cloud servers (AWS, Azure, GCP), open the port in the security group or firewall.

📦 3. Image Not Found or Manifest Unknown
🧠 Cause:
You’re pulling an image tag that doesn’t exist or a typo in the image name.

✅ Solution:

Verify the image name and tag:

sh
Copy code
docker pull ubuntu:20.04
If you created a custom image, make sure it’s pushed to Docker Hub:

sh
Copy code
docker push <username>/<image>:<tag>
Use docker images to confirm it exists locally.

⚙️ 4. Container Can’t Access the Internet
🧠 Cause:
Docker network misconfiguration or the daemon service issue.

✅ Solution:

Restart Docker:

sh
Copy code
sudo systemctl restart docker
Check network configuration:

sh
Copy code
docker network inspect bridge
Recreate the default bridge network if it’s broken:

sh
Copy code
docker network rm bridge
docker network create bridge
🧹 5. No Space Left on Device / Disk Full
🧠 Cause:
Old containers, images, or volumes consuming disk space.

✅ Solution:

Remove unused containers:

sh
Copy code
docker container prune
Remove unused images and volumes:

sh
Copy code
docker image prune -a
docker volume prune
Clean everything:

sh
Copy code
docker system prune -a
🧱 6. Permission Denied When Mounting Volumes
🧠 Cause:
The Docker process doesn’t have access to the mounted host directory.

✅ Solution:

Adjust folder permissions:

sh
Copy code
sudo chmod -R 755 /path/to/folder
Or change ownership:

sh
Copy code
sudo chown -R $USER:$USER /path/to/folder
Alternatively, run Docker with elevated permissions:

sh
Copy code
sudo docker run ...
🧩 7. Cannot Connect to the Docker Daemon
🧠 Cause:
Docker service is not running or you don’t have permission to use it.

✅ Solution:

Start the Docker service:

sh
Copy code
sudo systemctl start docker
Enable it on boot:

sh
Copy code
sudo systemctl enable docker
Check status:

sh
Copy code
sudo systemctl status docker
If you get permission errors:

sh
Copy code
sudo usermod -aG docker $USER
newgrp docker
📛 8. Name Already in Use
🧠 Cause:
A container with the same name already exists.

✅ Solution:

List containers:

sh
Copy code
docker ps -a
Remove the conflicting one:

sh
Copy code
docker rm -f <container_name>
Then re-run your container with a unique name.

⚡ 9. Error: Conflict. The Container Name is Already in Use
🧠 Cause:
You’re trying to reuse a container name that’s not removed.

✅ Solution:

sh
Copy code
docker rm -f <existing_container>
docker run --name new_container_name ...
🧰 10. Error: “Bind for 0.0.0.0:PORT Failed: Port Already Allocated”
🧠 Cause:
Another container or service is already using the same port.

✅ Solution:

Find which container is using the port:

sh
Copy code
docker ps
Stop or remove it:

sh
Copy code
docker stop <container_name>
docker rm <container_name>
Or use a different host port:

sh
Copy code
docker run -d -p 9090:80 nginx
🔄 11. Error: “Device or Resource Busy” When Removing Container
🧠 Cause:
Container is still running or mounted volume is busy.

✅ Solution:

sh
Copy code
docker stop <container_name>
docker rm -f <container_name>
If volume is busy:

sh
Copy code
docker volume ls
docker volume rm <volume_name>
🧠 12. Docker Build Fails (COPY/ADD Errors)
🧠 Cause:
Incorrect file paths or missing files in the build context.

✅ Solution:

Ensure the files exist in the Docker build context directory.

Use correct relative paths in Dockerfile.

Example:

Dockerfile
Copy code
COPY ./app /usr/src/app
🧩 13. Error: “Mounts Denied” (macOS/Windows)
🧠 Cause:
You’re trying to mount a host directory not shared with Docker Desktop.

✅ Solution:

Open Docker Desktop → Settings → Resources → File Sharing

Add the path you’re trying to mount (e.g., /Users, C:\Users).

🐢 14. Slow Docker Build or Run
🧠 Cause:
Large image layers, unused cache, or network latency.

✅ Solution:

Use lightweight base images (e.g., alpine).

Clean build cache:

sh
Copy code
docker builder prune
Optimize Dockerfile layers.

🔍 15. Container Stuck in Restart Loop
🧠 Cause:
Startup script or process crashes repeatedly.

✅ Solution:

Check logs:

sh
Copy code
docker logs <container_name>
Inspect restart policy:

sh
Copy code
docker inspect -f '{{.HostConfig.RestartPolicy.Name}}' <container_name>
Remove or fix misbehaving process and recreate the container.

🧩 16. Docker Compose Not Working / Service Fails
🧠 Cause:
Invalid syntax in docker-compose.yml or missing dependencies.

✅ Solution:

Validate YAML syntax:

sh
Copy code
docker-compose config
Recreate containers:

sh
Copy code
docker-compose down
docker-compose up -d
🔥 17. Error: “Too Many Open Files”
🧠 Cause:
System file descriptor limit reached.

✅ Solution:

Increase file descriptor limit temporarily:

sh
Copy code
ulimit -n 65535
Or modify /etc/security/limits.conf for a permanent fix.

🧠 Summary of Troubleshooting Commands
Task	Command
Check running containers	docker ps
View all containers	docker ps -a
View logs	docker logs <container_name>
Inspect metadata	docker inspect <container_name>
Check resource usage	docker stats
Prune unused resources	docker system prune -a
Restart Docker service	sudo systemctl restart docker
Check Docker network	docker network ls

💡 Pro Tips:

Always check logs before removing a container.

Keep Docker updated to avoid compatibility issues.

Use descriptive names for easier management.

Regularly prune unused containers, images, and volumes.
