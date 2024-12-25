# Terraform Setup for Jenkins

## **Project Title**

CI/CD Project Bank Leumi

## **Introduction**

This project sets up with terraform the jenkins controller in a private subnet connected to an ALB for the ui.
Another terraform for the eks sets up the eks cluster.
in the cluster i have a script that sets up argocd and an alb ingress controller and connectes them together for use and i have a dns in route53 that lets me connect to argocd and to the pods in browser through https with cname for each

## Features

- **Jenkins**: Deployed as an EC2 instance in a private subnet for security.
- **ALB**: Provides access to Jenkins from outside the private subnet.
- **Terraform Modules**: Modularized infrastructure as code for easy management and scaling and dynamic options with ec2 and nlb/alb.

## Deployment Steps

1. **Clone the Repository**
   Ensure you have the Terraform files ready in the `tf` directory.

2. **Configure AWS Access**
   Set up your AWS credentials in your environment or use an IAM role.

3. **Apply the Terraform Configuration**
   - Navigate to the Terraform directory:

     ```bash
     cd tf
     ```

   - Initialize Terraform:

     ```bash
     terraform init
     ```

   - Apply the configuration:

     ```bash
     terraform apply
     ```

4. **Access Jenkins**
   - Use the ALB DNS name to access Jenkins in your browser.

---

# Hello World App with Helm Deployment

## Overview

The Python app is containerized with Docker and deployed to a Kubernetes cluster using Helm. It is designed to be simple and scalable.

## Prerequisites

Before starting, make sure you have the following tools installed:

- [Docker](https://www.docker.com/)
- [Kubernetes](https://kubernetes.io/)
- [Helm](https://helm.sh/)

## Steps to Deploy the App

1. **Build and Push the Docker Image**
   - Build the Docker image:

     ```bash
     docker build -t your-dockerhub-username/hello-world-app .
     ```

   - Push the image to Docker Hub (or any registry):

     ```bash
     docker push your-dockerhub-username/hello-world-app
     ```

2. **Deploy with Helm**
   - Create a Helm chart (if not already created):

     ```bash
     helm create hello-world
     ```

   - Update the `values.yaml` in the Helm chart with your Docker image details:

     ```yaml
     image:
       repository: your-dockerhub-username/hello-world-app
       tag: latest
     ```

   - Install the Helm chart:

     ```bash
     helm install hello-world ./hello-world
     ```

3. **Access the Application**
   - Check the service to get the external IP:

     ```bash
     kubectl get svc
     ```

   - Open the application in your browser using the external IP.

4. **Clean Up**
   - To remove the deployment:

     ```bash
     helm uninstall hello-world
     ```

---

# Tools Used

- **Python & Flask**: For the Hello World app.
- **Docker**: For containerizing the application.
- **Kubernetes & Helm**: For deploying the app.
- **Terraform**: For provisioning the infrastructure (Jenkins, EC2, ALB, VPC, Subnets).

---

## Contact

For questions or issues, feel free to open an issue in this repository.
