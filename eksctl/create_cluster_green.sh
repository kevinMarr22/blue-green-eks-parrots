# Command to create an Amazon EKS cluster using eksctl
eksctl create cluster \
    --name K8S-Green \
    --region us-east-1 \
    --node-type t3.medium \
    --nodes 3 \
    --version 1.29