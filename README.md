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

## Repository Structure

The project is organized in the following structure:

.
├── modules/
│ ├── ec2/
│ ├── eks/
│ ├── jenkins/
│ └── networking/
├── environments/
│ ├── dev/
│ └── prod/
├── scripts/
├── .gitignore
├── README.md
└── main.tf

text

## Getting Started

1. Clone the repository:

git clone https://github.com/omerrevach/bank-leumi.git

text

2. Navigate to the desired environment directory:

cd bank-leumi/environments/dev

text

3. Initialize Terraform:

terraform init

text

4. Apply the Terraform configuration:

terraform apply

text
