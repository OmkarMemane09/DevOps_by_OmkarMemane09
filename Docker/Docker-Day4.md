
# 🌐 Docker Networking 

## 🧠 What is Docker Networking?
Docker networking allows containers to **communicate** with each other, with the **host system**, and with **external networks** (like the internet).  
It provides flexibility to isolate or expose containers depending on the use case.

---

## ⚙️ Why Networking is Important in Docker
- Enables communication between containers.
- Connects containers to the internet for updates or APIs.
- Allows linking multiple services (e.g., frontend ↔ backend ↔ database).
- Ensures network isolation for security.
- Useful in microservice-based architectures.

---

## 🔌 Types of Docker Network Drivers

<img width="500" height="1000" alt="docker-network-types-af647c9d85b25478f13c6a82dc0e3db0" src="https://github.com/user-attachments/assets/3adbfd91-9877-41ac-837e-adfcc96f5246" />

### 1. 🧱 **Bridge Network (Default)**
- Created automatically when Docker is installed.
- Used when no network is specified during container creation.
- Containers can communicate **via container names**.
- Provides internal DNS-based name resolution.
- Ideal for **standalone** containers.
**Example:**
```bash
docker network ls
docker run -d --name web1 nginx
docker exec -it web1 ping web2
Default Bridge Network Example Diagram:

Host Machine
 ├── Bridge Network (docker0)
 │     ├── Container A (web1)
 │     └── Container B (web2)
 ```
### 2. ⚡ Host Network
Removes isolation between the container and the host.
Container shares the host’s IP and network stack.
Best for performance-intensive apps (e.g., monitoring tools).

Example:
```bash
docker run -d --network host nginx
Note: No port mapping required (uses host’s network directly).
```

### 3. 🔒 None Network
Completely disables networking for the container.
Useful for security-sensitive applications or batch jobs.

Example:
```bash
docker run -d --network none nginx
```
### 4. 🌍 Overlay Network
Used for multi-host container communication.
Works in Docker Swarm mode or Kubernetes.
Connects containers across multiple Docker daemons.
Useful for distributed microservices.

Example (Swarm):
```bash
docker network create -d overlay my_overlay_net
```
### 5. 🧬 Macvlan Network
Assigns a unique MAC address to each container.
Makes container appear as a physical network device.
Containers can communicate directly with external networks.
Ideal for legacy apps needing Layer 2 access.

Example:
```bash
docker network create -d macvlan \
--subnet=192.168.1.0/24 \
--gateway=192.168.1.1 \
-o parent=eth0 my_macvlan_net
```
### 6. 🛰️ IPvlan Network
Similar to Macvlan but with more control over IP assignment.
Provides layer 3 (L3) isolation.
Commonly used in cloud environments for IP management.

Example:
```bash
docker network create -d ipvlan \
--subnet=192.168.2.0/24 \
--gateway=192.168.2.1 \
-o parent=eth0 my_ipvlan_net
```
## 🧾 Common Docker Network Commands

*Command	Description*
```bash
docker network ls	Lists all available networks
docker network create <name>	Creates a custom network
docker network inspect <name>	Displays detailed info about a network
docker network rm <name>	Deletes a network
docker network connect <network> <container>	Connects a running container to a network
docker network disconnect <network> <container>	Disconnects a container from a network
```
## 🧩 Working Example – Custom Network
```bash
Step 1: Create a new custom bridge network
docker network create my_custom_network

Step 2: Run containers in this network
docker run -d --name container1 --network my_custom_network nginx
docker run -d --name container2 --network my_custom_network nginx

Step 3: Test communication
docker exec -it container1 ping container2

Step 4: Inspect network details
docker network inspect my_custom_network
```
## 🌐 Creating Network with Subnet

*You can assign your own IP range:*
```bash
docker network create --subnet "192.168.0.0/16" --driver bridge newnetwork
Example Diagram:
nginx
Docker Host
 ├── newnetwork (Subnet: 192.168.0.0/16)
 │     ├── Container1 (192.168.0.2)
 │     └── Container2 (192.168.0.3)
🔄 Host Network Example

Run a container using the host’s network stack:
docker run -d -P --network host nginx:latest
```
