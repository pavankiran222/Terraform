# Terraform AWS VPC Basic Setup

This document covers the initial setup requirements for working with Terraform on macOS.

## Prerequisites Installation

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
└── provider.tf
```

## Next Steps

1. Configure AWS credentials
2. Initialize Terraform project
3. Create and apply infrastructure changes

Note: Additional documentation will be added as the project progresses.