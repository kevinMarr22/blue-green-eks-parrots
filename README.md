# Parrot Deployment 
This repository contains the necessary configurations and scripts to build, deploy, and manage the Parrot application using AWS EKS clusters, Istio for traffic management, and GitHub Actions for CI/CD. Follow the instructions below to set up and deploy the application.

## Prerequisites

Before you start, ensure you have the following:

- Read the pptx to understand in deep dive this idea: [Slides](https://docs.google.com/presentation/d/1MjLboSR0eZZxq5sw2i6IRmAA2_ew1zOWciTyA85wzhA/edit?usp=sharing) 
- An AWS account with appropriate IAM permissions
- AWS CLI configured with necessary credentials
- GitHub repository with appropriate secrets configured
- Node.js and Docker installed locally

## Secrets Configuration
In your GitHub repository, configure the following secrets:

- **AWS_ACCESS_KEY_ID:** Your AWS Access Key ID
- **AWS_SECRET_ACCESS_KEY:** Your AWS Secret Access Key
- **AWS_ACCOUNT:** Your AWS Account ID


# Setup Guide

## 1. Create EKS Clusters

### For Blue-Green Deployment in One Cluster

**Create Blue-Green Cluster:**
- Trigger the GitHub Action workflow `wk-create-cluster.yaml` manually.
- This will create a single EKS cluster named `K8S-Blue-Green`.

**Create Blue and Green Clusters Separately:**
- Trigger the GitHub Action workflows `wk-create-2-clusters-blue-green.yaml` manually.
- This will create two separate EKS clusters named `K8S-Blue` and `K8S-Green`.

## 2. Install Istio

**Install Istio on the Cluster:**
- Trigger the GitHub Action workflow `install-istio.yaml` manually.
- Provide necessary inputs for `ISTIO_VERSION`, `CLUSTER_NAME`, and `REGION`.

## 3. Build and Push Docker Image

**Build and Push Docker Image:**
- Ensure the main branch is up to date.
- GitHub Actions workflow `build-push.yaml` is triggered on every push to the main branch.
- This workflow will build the Docker image from the `app` directory and push it to the ECR repository.

## 4. Deploy Application

**Deploy to Blue Cluster:**
- Update the `k8s/blue/base/deployment-blue.yaml` and `overlay/kustomization.yaml` with the correct image tag.
- Apply the Kubernetes resources:
  ```sh
  kubectl apply -k k8s/blue/overlay

## Deploy to Green Cluster:

1. Update the `k8s/green/base/deployment-green.yaml` and `overlay/kustomization.yaml` with the correct image tag.
2. Apply the Kubernetes resources:

    ```sh
    kubectl apply -k k8s/green/overlay
    ```

## Traffic Management with Istio

    You can set 100 weigth for green or blue according to you need. 
    - Apply the DestinationRule:

    ```sh
    kubectl apply -k k8s/green/overlay
    ```

## Clean Up

1. Remove EKS Cluster:

    - Trigger the GitHub Action workflow `wk-remove-cluster.yaml` manually.
    - This will delete the EKS cluster named `K8S-Blue-Green`.

## Directory Structure

- `.github/workflows/`: Contains GitHub Actions workflows for CI/CD.
- `app/`: Contains the Parrot application code.
- `eksctl/`: Contains scripts to create and manage EKS clusters.
- `k8s/`: Contains Kubernetes manifests for deploying the application.
- `istio/`: Contains Istio configuration files.
