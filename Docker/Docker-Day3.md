## 🚀Docker Image Management, Docker Hub and AWS ECR .
---
## 🐳 What is a Docker Image?

A **Docker Image** is a **lightweight, stand-alone, and executable software package** that includes everything needed to run an application:
- Application code  
- Runtime (e.g., Java, Python, Node.js)  
- Libraries and dependencies  
- Configuration files and environment variables  

In short — it’s a **blueprint** for creating **Docker containers**.

---

## 🧩 Key Characteristics

| Feature | Description |
|----------|-------------|
| **Immutable** | Once built, images cannot be changed — new versions are created instead. |
| **Layered Structure** | Each command in a Dockerfile creates a new read-only layer. |
| **Portable** | Can run on any system with Docker installed. |
| **Versioned** | Identified using tags like `latest`, `v1`, or `stable`. |
| **Reusable** | Common base images (like `ubuntu`, `node`, etc.) can be shared and reused. |

---

## ⚙️ How Docker Images Work

1. You **pull** an image from a registry (like Docker Hub or AWS ECR).  
2. Docker stores it locally and creates **containers** from it.  
3. Each image is made up of **layers** stacked together — improving efficiency and reuse.

Example:  
If multiple images use the same base (e.g., `ubuntu`), Docker reuses those layers instead of downloading again.

---

## 🧠 Structure of a Docker Image

Each image consists of:
- **Base Layer:** The core operating system (e.g., Ubuntu, Alpine).
- **Intermediate Layers:** Added dependencies, libraries, and configurations.
- **Top Layer:** Your application code and runtime settings.

Example structure:
## 📦 Common Docker Image Commands

| Command | Description |
|----------|-------------|
| `docker pull <image>:<tag>` | Downloads an image from Docker Hub or another registry. |
| `docker images` | Lists all images stored locally. |
| `docker rmi <image_id>` | Removes a local image. |
| `docker tag <src>:<tag> <dest>:<tag>` | Creates a new alias (tag) for an image. |
| `docker build -t <name>:<tag> .` | Builds a new image from a Dockerfile. |
| `docker push <repo>:<tag>` | Pushes an image to a registry. |

---

# 🐳 Docker Hub 

---

## 🌐 What is Docker Hub?

**Docker Hub** is a **cloud-based container registry** provided by Docker.  
It’s the **official public repository** where you can:
- Store and share Docker images
- Pull ready-to-use images (like Ubuntu, Nginx, MySQL, etc.)
- Push your own images for others or private use
- Automate builds and manage repositories

---

## 🧱 Structure of Docker Hub

| Component | Description |
|------------|--------------|
| **Repository** | A collection of Docker images (e.g., `omkarmemane9/ubuntu-app`) |
| **Image** | Specific version (tag) stored inside a repository |
| **Tag** | Label to identify image versions (e.g., `latest`, `v1`, `dev`) |
| **User / Organization** | The account or team that owns the repository |

Example:  
👉 `omkarmemane9/ubuntu:v1`  
- `omkarmemane9` → Docker Hub username  
- `ubuntu` → Repository name  
- `v1` → Tag name

---

## ⚙️ Prerequisites

Before pushing or pulling images:
1. Install Docker on your system  
2. Create a Docker Hub account → [https://hub.docker.com](https://hub.docker.com)
3. Login to Docker from terminal
  docker login

## 🧰 Example Workflow

```bash

# Step 1: Pull base image
docker pull ubuntu:latest

# Step 2: Build your own image using Dockerfile
docker build -t myapp:v1 .

# Step 3: List available images
docker images

# Step 4: Run container from image
docker run -it myapp:v1 /bin/bash
```

## 🧾 Example Workflow
```bash

# 1. Login to Docker Hub
docker login

# 2. Tag local image
docker tag ubuntu:latest omkarmemane9/ubuntu:v1

# 3. Push image to Docker Hub
docker push omkarmemane9/ubuntu:v1

# 4. Pull image on another machine
docker pull omkarmemane9/ubuntu:v1

# 5. Verify image locally
docker images

# 6. Run container
docker run -it omkarmemane9/ubuntu:v1 /bin/bash
```
-----------------------------------------------

# ☁️ AWS ECR (Elastic Container Registry) — Complete Guide with Steps & Explanations

---

## 🧭 What is AWS ECR?

**Amazon Elastic Container Registry (ECR)** is a **fully managed Docker container registry** by AWS.  
It allows you to:
- Store, manage, and deploy Docker container images securely.
- Integrate seamlessly with **AWS services** like ECS, EKS, and Lambda.
- Replace Docker Hub for **private and scalable** image hosting.

---

## 🧱 Structure of AWS ECR

| Component | Description |
|------------|--------------|
| **Registry** | The main container registry for your AWS account (one per region). |
| **Repository** | Stores your Docker images (e.g., `my-cont`, `web-app`). |
| **Image** | A specific version of your container (tagged image). |
| **Tag** | Version label (like `v1`, `latest`, `prod`). |

Example:  
👉 `472173421444.dkr.ecr.ap-south-1.amazonaws.com/my-cont:v1`

- `472173421444` → AWS Account ID  
- `dkr.ecr.ap-south-1.amazonaws.com` → AWS ECR domain for your region  
- `my-cont` → Repository name  
- `v1` → Tag name

---

## ⚙️ Prerequisites

 ```bash
Before using ECR, make sure you have:
1. AWS Account with IAM user access  
2. Installed and configured **AWS CLI**  
   aws configure

Enter:
AWS Access Key ID
AWS Secret Access Key
Region (e.g., ap-south-1)
Output format (json)
Installed Docker on your local or EC2 instance
```

## 🪜 Steps to Push Docker Image to AWS ECR
```bash

Step 1: Create a Repository in ECR
You can create it via AWS Console or CLI.

* Using AWS CLI:
aws ecr create-repository --repository-name my-cont
Output Example:
{
    "repository": {
        "repositoryArn": "arn:aws:ecr:ap-south-1:472173421444:repository/my-cont",
        "repositoryUri": "472173421444.dkr.ecr.ap-south-1.amazonaws.com/my-cont"
    }
}
Step 2: Authenticate Docker with ECR
This command logs your Docker CLI into AWS ECR.
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 472173421444.dkr.ecr.ap-south-1.amazonaws.com
✅ If successful → “Login Succeeded”

Step 3: Tag Your Local Docker Image
Tag your existing Docker image to match your ECR repository.
docker tag ubuntu:latest 472173421444.dkr.ecr.ap-south-1.amazonaws.com/my-cont:v1

ubuntu:latest → local image name
my-cont:v1 → repository name & version

You’re preparing this image for ECR push.

Step 4: Push Image to ECR
Now push the tagged image to your AWS ECR repository.

 docker push 4721731444.dkr.ecr.ap-south-1.amazonaws.com/my-cont:v1
 
🟢 This uploads your image layers to ECR, layer by layer.

Example Output:
The push refers to repository [472173421444.dkr.ecr.ap-south-1.amazonaws.com/my-cont]
latest: digest: sha256:fd95c5e2b9a size: 1573

Step 5: Verify Image in AWS Console
Go to AWS Console → ECR → Repositories → my-cont
Check that your image with tag v1 is uploaded.

 ```
## 📥 Pull Docker Image from AWS ECR
```bash

If you want to use that image on another EC2 instance or local system:

Authenticate again (if required)
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 472173421444.dkr.ecr.ap-south-1.amazonaws.com

# Pull the image
docker pull 472173421444.dkr.ecr.ap-south-1.amazonaws.com/my-cont:v1

# Run the container
docker run -it 472173421444.dkr.ecr.ap-south-1.amazonaws.com/my-cont:v1 /bin/bash
``` 
## 🧠 Explanation of Each Command
```bash

aws ecr create-repository	Creates a new repository in AWS ECR
aws ecr get-login-password	Retrieves a temporary authentication token
docker login	Logs Docker into ECR using AWS credentials
docker tag	Retags a local image for ECR repository
docker push	Uploads the image to ECR
docker pull	Downloads image from ECR to your system
docker run	Runs a container from the pulled image

```
## 🧾 Workflow Summary
```bash
# 1. Configure AWS CLI
aws configure

# 2. Create repository
aws ecr create-repository --repository-name my-cont

# 3. Authenticate Docker with ECR
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 472173421444.dkr.ecr.ap-south-1.amazonaws.com

# 4. Tag local image
docker tag ubuntu:latest 4721731444.dkr.ecr.ap-south-1.amazonaws.com/my-cont:v1

# 5. Push image to ECR
docker push 4773421444.dkr.ecr.ap-south-1.amazonaws.com/my-cont:v1

# 6. Pull image (on another instance)
docker pull 4721734214.dkr.ecr.ap-south-1.amazonaws.com/my-cont:v1

```
