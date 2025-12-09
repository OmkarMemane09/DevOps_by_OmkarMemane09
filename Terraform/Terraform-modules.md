# 📌 1. What is a Terraform Module?

A **Terraform Module** is a folder that contains multiple `.tf` files used to create related resources.

Think of a module like a **function in programming**:

- You define it once  
- Pass **inputs** (variables)  
- Create **resources**  
- Return **outputs**  
- Reuse the module anywhere  

### ✔ The root folder = the **root module**  
### ✔ The folders inside `modules/` = **child modules**

Modules help in:

- Reusability  
- Cleaner code  
- Standardization  
- Easy multi-environment (dev, test, prod) setups  
- Scalability for large infrastructures  

---

#  Terraform Modules: VPC, Subnet & EC2 

This repository demonstrates how to build **production-ready Terraform modules** for:

- VPC  
- Subnet  
- EC2  

You will learn how modules work, how to organize Terraform code on a server, how dependencies flow between modules, and how to write reusable infrastructure as code (IaC).

---

# 📌 2. Project Structure (Production Ready)
```tree
terraform-project/
  │── main.tf
  │── variables.tf
  │── outputs.tf
  │── provider.tf
  │
  └── modules/
  |  └── vpc/
  │  |   ├── main.tf
  │  |   ├── variables.tf
  │  |   └── outputs.tf
  │  |
  ├  └── subnet/
  │  |    ├── main.tf
  │  |    ├── variables.tf
  │  |    └── outputs.tf
  │  |
  |  └──ec2/
  |     ├── main.tf
  |     ├── variables.tf
  |     └── outputs.tf
```
yaml
Copy code

---

#  3. Creating This Structure on a Server

### **Step 1 — Create project folder**

```bash
mkdir terraform-project
cd terraform-project
```
### **Step 2 — Create module folders**
```bash
mkdir -p modules/vpc modules/subnet modules/ec2
```
### **Step 3 — Create root module files
```bash
touch main.tf variables.tf outputs.tf provider.tf
```
### **Step 4 — Create child module files**
```bash
touch modules/vpc/{main.tf,variables.tf,outputs.tf} \
      modules/subnet/{main.tf,variables.tf,outputs.tf} \
      modules/ec2/{main.tf,variables.tf,outputs.tf}
```

📌 4. Root Module — main.tf
This is the entry point that calls all modules.

```hcl

provider "aws" {
  region = "us-east-1"
}

# Call VPC module
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

# Call Subnet module
module "subnet" {
  source      = "./modules/subnet"
  vpc_id      = module.vpc.vpc_id
  subnet_cidr = "10.0.1.0/24"
}

# Call EC2 module
module "ec2" {
  source        = "./modules/ec2"
  subnet_id     = module.subnet.subnet_id
  instance_type = "t2.micro"
}
```
## 5. VPC Module (modules/vpc)
```
nano main.tf
```
```hcl
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "MyVPC"
  }
}
```
```
 nano variables.tf
```
```hcl
variable "vpc_cidr" {
  type = string
}
```
```
nano outputs.tf
```
```hcl
output "vpc_id" {
  value = aws_vpc.this.id
}
```
## 6. Subnet Module (modules/subnet)
```
nano main.tf
```
```hcl
resource "aws_subnet" "this" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "MySubnet"
  }
}
```
```
nano variables.tf
```
```hcl
variable "vpc_id" {}
variable "subnet_cidr" {}
```
```
nano outputs.tf
```
```hcl
output "subnet_id" {
  value = aws_subnet.this.id
}
```
## 7. EC2 Module (modules/ec2)

Instead of using a hardcoded AMI, we fetch the latest Amazon Linux 2 AMI dynamically.

```
nano main.tf
```
```hcl
# Fetch latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2 instance
resource "aws_instance" "this" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = {
    Name = "MyEC2"
  }
}
```
```
nano variables.tf
```
```hcl
variable "instance_type" {}
variable "subnet_id" {}
```
```
nano outputs.tf
```
```hcl
output "instance_id" {
  value = aws_instance.this.id
}
```
## 8. Dependencies in Terraform

Terraform decides the order of resource creation using dependencies.

**1️⃣ Implicit Dependency**
Created automatically when one resource references another.

```
subnet_id = aws_subnet.this.id
```
Meaning:

 - EC2 waits for Subnet

 - Subnet waits for VPC

No need for depends_on in this case.

**2️⃣ Explicit Dependency**
Use depends_on when the dependency is not visible through variables.

Example:

```hcl

resource "aws_instance" "this" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  depends_on = [
    aws_vpc.this
  ]
}
```
## 9. Module Flow Diagram
```tree
Root Module (main.tf)
      │
      ├── calls module "vpc"
      │         ↓
      │     creates VPC → outputs vpc_id
      │
      ├── calls module "subnet"
      │         ↓
      │     uses vpc_id → creates subnet → outputs subnet_id
      │
      └── calls module "ec2"
                ↓
            uses subnet_id → launches EC2
```
## 10. Initialize and Apply Terraform
```
terraform init      # download modules & providers
terraform validate  # validate syntax
terraform plan      # preview resources
terraform apply     # create infrastructure
terraform destroy   # delete resources
```


