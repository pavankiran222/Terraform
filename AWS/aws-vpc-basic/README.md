# Terraform AWS VPC with EC2 Setup

This project demonstrates the creation of a complete AWS networking setup with a VPC, public/private subnets, and a secure EC2 instance using Terraform. This infrastructure-as-code project showcases essential AWS networking concepts and secure instance deployment.

![Project Architecture](architecture.png)

## Project Overview

This project creates:
1. A VPC with public and private subnets
2. Internet Gateway for public internet access
3. NAT Gateway for private subnet internet access
4. Security Groups for SSH access
5. EC2 instance in the public subnet
6. All necessary route tables and associations

## Prerequisites

### 1. Install Homebrew (Package Manager for macOS)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installation, add Homebrew to your PATH:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 2. Install Terraform

There are two ways to install Terraform:

#### Option 1: Using Homebrew (v1.5.7 - last open-source version)

```bash
brew install terraform
```

Note: Homebrew installs Terraform v1.5.7 which is the last version under the open-source license.

#### Option 2: Manual Installation (Latest Version 1.13.3)

1. Download the latest version:
```bash
curl -O https://releases.hashicorp.com/terraform/1.13.3/terraform_1.13.3_darwin_arm64.zip
```

2. Unzip the downloaded file:
```bash
unzip terraform_1.13.3_darwin_arm64.zip
```

3. Move the binary to a directory in your PATH:
```bash
sudo mv terraform /usr/local/bin/
```

4. Clean up the zip file:
```bash
rm terraform_1.13.3_darwin_arm64.zip
```

Note: This version is under the BUSL (Business Source License). Make sure you comply with the license terms.

### 3. Verify Installation

Verify that Terraform is installed correctly:

```bash
terraform --version
```

You should see output similar to:
```
Terraform v1.13.3
on darwin_arm64
```

## Project Structure

```
aws-vpc-basic/
├── README.md
├── provider.tf
├── main.tf
├── architecture.png
└── .gitignore
```

## Infrastructure Components

### VPC and Networking
- VPC CIDR: 10.0.0.0/16
- Public Subnet: 10.0.1.0/24 (us-east-2a)
- Private Subnet: 10.0.2.0/24 (us-east-2b)
- Internet Gateway for public subnet access
- NAT Gateway for private subnet internet access
- Appropriate route tables and associations

### EC2 Instance
- Amazon Linux 2023 AMI
- t2.micro instance type
- Located in public subnet
- SSH access enabled
- Security group with port 22 open

## Deployment Instructions

### Manual Deployment
```bash
git clone https://github.com/pavankiran222/Terraform.git
cd Terraform/AWS/aws-vpc-basic
```

2. Generate SSH key pair:
```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/terraform_key -N ""
```

3. Initialize Terraform:
```bash
terraform init
```

4. Review the infrastructure plan:
```bash
terraform plan
```

5. Apply the configuration:
```bash
terraform apply
```

6. Connect to the EC2 instance:
```bash
ssh -i ~/.ssh/terraform_key ec2-user@<instance_public_ip>
```

## Validation Screenshots

For project validation, you can take screenshots of:

1. AWS Console showing:
   - VPC configuration
   - Running EC2 instance
   - Security Groups
   ![VPC Dashboard](vpc-dashboard.png)

2. Terminal showing:
   - Successful Terraform apply
   - SSH connection to the instance
   ![Terraform Apply](terraform-apply.png)

3. Architecture Diagram (you can create using draw.io or AWS diagrams)
   ![Architecture](architecture.png)

### Manual Workflow Deployment

This project includes a GitHub Actions workflow that can be manually triggered to manage your infrastructure.

1. Configure GitHub Secrets:
   - Go to your GitHub repository → Settings → Secrets and Variables → Actions
   - Add the following secrets:
     - `AWS_ACCESS_KEY_ID`: Your AWS access key
     - `AWS_SECRET_ACCESS_KEY`: Your AWS secret key

2. To run the workflow:
   - Go to your repository's Actions tab
   - Select "Terraform CI/CD" workflow
   - Click "Run workflow"
   - Choose one of the following actions:
     - `plan`: Preview changes without applying
     - `apply`: Apply infrastructure changes
     - `destroy`: Destroy infrastructure

The workflow performs these steps:
1. Checks out the code
2. Configures AWS credentials
3. Sets up Terraform
4. Formats and validates the code
5. Based on your selection:
   - Shows the plan for review
   - Applies the infrastructure changes
   - Destroys the infrastructure

### Workflow Status
[![Terraform CI/CD](https://github.com/pavankiran222/Terraform/actions/workflows/terraform.yml/badge.svg)](https://github.com/pavankiran222/Terraform/actions/workflows/terraform.yml)

## Clean Up

To avoid AWS charges, destroy the infrastructure when not in use:

### Manual Cleanup
```bash
terraform destroy
```

## Security Notes

1. The SSH key pair is stored locally at ~/.ssh/terraform_key
2. Security group is configured to allow SSH access
3. EC2 instance has a public IP for SSH access
4. Terraform state files contain sensitive information

## Technologies Used

- Terraform v1.13.3
- AWS Provider
- Amazon Linux 2023
- SSH for secure access

## Best Practices Implemented

1. Infrastructure as Code using Terraform
2. Modular network design with public/private subnets
3. Security group implementation
4. Proper resource tagging
5. State file management