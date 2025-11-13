 # 🚀 EKS Cluster Setup and EC2 Integration Guide

This guide provides a **complete step-by-step process** for setting up an **Amazon EKS cluster** and connecting it with an **EC2 instance**.  

---

##  Create an EKS Cluster

1. Navigate to **Amazon EKS** in the AWS Management Console.  
2. Choose **Create Cluster**.  
3. Select **Custom (without node group)** option.
4. Off the auto mode
5. Enter a **Cluster Name**.  
6. Under **Cluster Service Role**, click **Create Role → Next → Next**, then name and create the role.  
7. Refresh the page and select the **Recommended Role**.  
8. Proceed with **default settings** for compute and logging.  
9. Under **Networking**, attach a **Security Group** that allows **All Traffic**.  
10. Review all configurations and click **Create**.

---

##  Create and Connect an EC2 Instance

1. Open the **EC2 Dashboard** in a new tab.  
2. Launch a new instance with the following configuration:
   - **AMI:** Ubuntu  
   - **Instance Type:** c7flex.large  
   - **Security Group:** Same as used in the EKS Cluster  
3. Launch and **connect** to the instance using SSH.  

---

####  Install `kubectl`

```bash

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```
#### Validate the binary
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
```
```bash
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
```
#### Install kubectl
```bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```
#### If you don’t have root access:
```bash
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
```
#### Verify installation:
```bash
kubectl version --client
```
#### Install AWS CLI
```bash
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
#### Configure AWS CLI

To connect to AWS services:
```bash
aws configure
```
Provide your Access Key ID, Secret Access Key, Region, and Output format when prompted.

```bash
*If not crated* if it is not created manually then only 
###  Create EKS Cluster using eksctl

Use eksctl to create the cluster:
 *If not crated*
```bash
eksctl create cluster --name demo-ekscluster --region us-east-1 --version 1.27 --nodegroup-name linux-nodes --node-type t2.micro --nodes 2
```


#### Connect to the EKS Cluster
Update kubeconfig to connect your EC2 to the EKS cluster:
```bash
aws eks update-kubeconfig --name demo-ekscluster --region us-east-1
```
#### Check cluster info:
```bash
kubectl cluster-info
```
#### Delete the EKS Cluster

If you need to delete the cluster:

```bash
eksctl delete cluster --name demo-ekscluster --region ap-south-1
```
##  Add Node Group in Cluster

Step 1. Go to your EKS Cluster in AWS Console.

Step 2. Navigate to Compute → Add Node Group.

Step 3. Create a new IAM Role with minimal permissions.

Step 4. Select the instance type same as EC2 (c7flex.large).

Step 5. Once nodes are created, verify from your EC2 using:

```bash
    kubectl get nodes
```
---
### Practice Kubernetes Commands

After connecting nodes successfully, practice the following:

#### Check nodes
```bash
kubectl get nodes
```

#### Run a sample Nginx pod
```bash
kubectl run nginx-pod --image=nginx
```

#### List all pods
```bash
kubectl get pods
```

#### Describe a pod
```bash
kubectl describe pod nginx-pod
```

#### Explore API resources
```bash
kubectl api-resources
```
