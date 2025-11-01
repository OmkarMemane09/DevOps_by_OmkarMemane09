# 🚀 Deploying a Website using Docker Image, Container and Docker File .

### **Step 1: Create an EC2 Instance**
- Launch an **EC2 instance** (Ubuntu preferred).

---

### **Step 2: Connect to the Instance and Setup Docker**
```bash
sudo -i
apt update
apt install docker.io -y

```
### Step 3: Create Your Website Files
```bash
nano index.html
Paste your HTML code here and save it using:
CTRL + O → ENTER → CTRL + X
```
### Step 4: Create a Dockerfile
```bash
nano Dockerfile

Paste the following content:
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80

```
### Step 5: Build the Docker Image
```bash
docker build -t img1

```

### Step 6: Verify Docker Images
```bash
docker images
```
### Step 7: Run the Docker Container
```bash
docker run -ti -d --name nginx -p 80:80 img1
```
### Step 8: Access Your Website
Open your browser and hit the EC2 Public IP.
🎉 Your website should now be live!
