# Infrastructure as Code for Jenkins, EKS, and EC2 Deployment

## Project Overview

This project implements a comprehensive Infrastructure as Code (IaC) solution using Terraform to set up and manage various AWS services including Jenkins, EKS (Elastic Kubernetes Service), and EC2 instances. The infrastructure is designed with security, scalability, and ease of management in mind.

## Key Components

### 1. Jenkins Controller

- Custom AMI with pre-configured Jenkins controller and dynamic node agent
- Deployed in a private subnet for enhanced security
- Connected to an Application Load Balancer (ALB) for traffic distribution
- Easily adaptable to new VPCs by changing the subnet ID

### 2. EKS Cluster

- Kubernetes cluster set up using Terraform
- Ingress Nginx Controller for managing incoming traffic
- ArgoCD integration for GitOps-based deployments
- Accessible via HTTPS:
  - ArgoCD: https://argocd.stockpnl.com
  - Main Application: https://stockpnl.com

### 3. EC2 Instance with Network Load Balancer

- EC2 instance with restricted inbound traffic (only from IP 91.231.246.50)
- Assigned an Elastic Public IP
- Connected to a Network Load Balancer for traffic distribution

## Infrastructure Design

- Modular Terraform structure for reusability and maintainability
- Secure network design with public and private subnets
- Use of AWS managed services for reduced operational overhead

## Security Features

- Jenkins controller in a private subnet
- Restricted EC2 access
- HTTPS implementation with valid SSL certificates
- EKS cluster with proper IAM roles and policies

## Deployment and Access

- Jenkins accessible through ALB
- ArgoCD and main application accessible via custom domains with HTTPS
- EC2 instance accessible only from specified IP

# Infrastructure Deployment Guide

## Getting Started

### 1. Clone the Repository

Clone the project repository:

git clone https://github.com/omerrevach/bank-leumi.git
cd bank-leumi

text

### 2. Set Up Jenkins with ALB

Navigate to the Jenkins ALB configuration directory:

cd tf/jenkins_alb_root

text

Initialize and apply Terraform configuration:

terraform init
terraform plan
terraform apply

text

#### Jenkins Post-Configuration

1. Open Jenkins UI
2. Manage Jenkins -> Configure System
   - Update proxy settings with ALB DNS

3. Install Required Plugins:
   - Amazon EC2
   - Docker
   - Docker Pipeline
   - SSH Agent

4. Configure Dynamic Node Agent
   - Manage Jenkins -> Cloud
   - Update subnet ID for the dynamic node agent

### 3. Set Up EKS Cluster

Navigate to EKS setup directory:

cd ../../tf/eks_setup_root

text

Initialize and apply Terraform configuration:

terraform init
terraform plan
terraform apply

text

### 4. Deploy Nginx Ingress and ArgoCD

Deploy Nginx Ingress Controller and ArgoCD:

cd ../../helm
./setup-alb-argocd.sh

text

#### Access Points
- ArgoCD: https://argocd.stockpnl.com
- Application: https://stockpnl.com

### 5. EC2 with Network Load Balancer

> **Note:** This step uses existing VPC details from S3 remote Terraform state

- Retrieve VPC details from S3 bucket
- Configure NLB and EC2 instance
- Restrict traffic to IP 91.231.246.50
- Assign Elastic Public IP
- Connect EC2 to Network Load Balancer