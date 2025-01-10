
# Helm Charts Repository

This repository contains Helm charts for deploying various applications and services to Kubernetes. The repository is designed to be used with ArgoCD for continuous deployment and synchronization with your Kubernetes clusters.


### Charts

- app-server: Helm chart for the app server.
- web-server: Helm chart for the web server.


### ArgoCD Integration

ArgoCD can be configured to monitor this repository and automatically synchronize changes to your Kubernetes clusters.

## Updating Values

When a new container image is built, you need to update the corresponding value files in the `values-files` directory for each Helm chart. This ensures that the new image tag is applied during the deployment process.

## Usage

- Clone this repository to your local machine.
- Modify the value files in the directory to reflect the new image tags and any other environment-specific configurations.
- Commit your changes and push them to the repository.
- ArgoCD will detect the changes and synchronize them to your Kubernetes cluster.
