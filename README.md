# Project Overview

This project is a mono-repository setup designed to demonstrate a complete DevOps workflow for web application stack deployment on AWS using Kubernetes Helm, and ArgoCD. Includes elements below:

## Terraform

Contains Terraform configurations for provisioning the necessary infrastructure on AWS, including EKS , ECR and ArgoCD.
  

## Helms

Contains Helm charts and values files for deploying the Web Server, MySQL Server, and App Server to 

## Apps

- Contains the code and build configuration for the App Server.
- Contains the code and build configuration for the Web Server.
- Both used github action for CI/CD