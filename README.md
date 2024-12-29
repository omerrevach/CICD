# Bank Leumi CI/CD Project

## Overview

This project automates the infrastructure provisioning and deployment processes for Bank Leumi using **Terraform**, **Jenkins**, and **GitLab**. The goal is to create a seamless CI/CD pipeline that integrates code changes from GitLab, triggers builds in Jenkins, and deploys applications to an AWS EKS cluster.

<img src="bank-leumi.drawio.svg">

## Infrastructure Automation

### Terraform Setup

Utilization of Terraform to automate the creation of the following AWS resources:

- **VPC**: A Virtual Private Cloud to host our resources securely.
- **Subnets**: Private subnets for Jenkins and GitLab, ensuring they are not exposed directly to the internet.
- **Application Load Balancer (ALB)**: To manage incoming traffic to our services.
- **EKS Cluster**: An Elastic Kubernetes Service cluster for deploying containerized applications.
- **Network Load Balancer (NLB)**: For handling high-throughput traffic.
- **Test EC2 Instances**: To validate our infrastructure setup.

The Terraform configuration is modularized for reusability and dynamic configuration, allowing easy adjustments to parameters like instance types, regions, and scaling options.

### Continuous Integration

When a change is made in GitLab, Jenkins automatically triggers a CI job that performs static analysis on the code using tools like Bandit and Pylint. If all checks pass, Jenkins builds a Docker image and pushes it to Docker Hub.

### Continuous Deployment

After building the Docker image, Jenkins triggers another job that handles:

- Setting up the NGINX Ingress Controller if not already deployed.
- Deploying ArgoCD for managing application deployments in Kubernetes.
- Updates values.yaml tag with the build number
- Synchronizing application states in Kubernetes using ArgoCD.

## DNS Configuration with Route 53

To enable secure access to ArgoCD and deployed applications, configure DNS records using AWS Route 53:

- An A record is created for `argocd.stockpnl.com`, pointing to the NGINX Ingress Controller's DNS name, allowing HTTPS access.
