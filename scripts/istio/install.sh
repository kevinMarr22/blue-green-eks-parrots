#!/bin/bash

# Variables
ISTIO_VERSION="1.22" # Replace with the desired version
CLUSTER_NAME="K8S-Blue-Green" # Replace with your EKS cluster name
REGION="us-east-1" # Replace with your AWS region

# Ensure the script exits if any command fails
set -e

# Update the package list and install curl and jq if not already installed
sudo apt-get update
sudo apt-get install -y curl jq

# Download istioctl
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} sh -

# Add istioctl to the PATH
export PATH=$PWD/istio-${ISTIO_VERSION}/bin:$PATH

# Verify the istioctl installation
istioctl version

# Associate IAM OIDC provider with the EKS cluster if not already done
eksctl utils associate-iam-oidc-provider --region ${REGION} --cluster ${CLUSTER_NAME} --approve

# Install the Istio base chart which contains cluster-scoped resources
istioctl install --set profile=demo -y

# Verify the installation
kubectl get pods -n istio-system

echo "Istio installation completed successfully!"
