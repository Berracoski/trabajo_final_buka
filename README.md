# AWS EKS Cluster & Application Deployment with Terraform

This repository contains Infrastructure as Code (IaC) to deploy a robust Kubernetes cluster on Amazon Elastic Kubernetes Service (EKS) in AWS. It includes all necessary infrastructure components, such as networking (VPC, subnets), IAM roles, storage, EKS node groups, and a bastion host. Additionally, it automates the deployment of a sample Nginx application and a comprehensive monitoring stack using Prometheus and Grafana.

This project is designed to facilitate automated, reproducible, and scalable cloud infrastructure provisioning for container orchestration environments.

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Deployment Guide](#deployment-guide)
  - [Step 1: Clone the Repository](#step-1-clone-the-repository)
  - [Step 2: Deploy Core Infrastructure (EKS Cluster, VPC, etc.)](#step-2-deploy-core-infrastructure-eks-cluster-vpc-etc)
  - [Step 3: Configure `kubectl` Access](#step-3-configure-kubectl-access)
  - [Step 4: Deploy Monitoring Stack (Prometheus & Grafana)](#step-4-deploy-monitoring-stack-prometheus--grafana)
  - [Step 5: Deploy Sample Application (Nginx)](#step-5-deploy-sample-application-nginx)
- [Accessing Services](#accessing-services)
  - [Accessing Grafana](#accessing-grafana)
- [Cleanup](#cleanup)
- [Important Notes](#important-notes)
- [Authors](#authors)
- [License](#license)

## Features

- **Automated EKS Cluster Deployment**: Provision a production-ready EKS cluster with Terraform.
- **Network Infrastructure**: Sets up a dedicated VPC, public and private subnets, NAT Gateways, and security groups.
- **IAM Roles**: Configures necessary IAM roles for EKS and EC2 instances.
- **Node Groups**: Deploys managed EKS node groups.
- **Bastion Host**: Includes a bastion host for secure access to private resources.
- **Monitoring Stack**: Deploys Prometheus and Grafana using Helm charts via Terraform for comprehensive cluster monitoring.
- **Sample Application**: Deploys a simple Nginx application as an example workload.
- **Idempotent Deployments**: Leverage Terraform for consistent and repeatable infrastructure provisioning.

## Project Structure
```
.
├── app-nginx/ # Terraform configurations for deploying a sample Nginx application on EKS.
├── docs/ # Supplementary documentation (if any).
├── infra/ # Core Terraform configurations for AWS infrastructure (VPC, EKS cluster, IAM, etc.).
├── monitoring/ # Terraform configurations for deploying Prometheus and Grafana on EKS using Helm.
├── user_data.sh # Script executed on EC2 instances for node/bastion host configuration.
├── .gitignore # Git ignore file for common Terraform and environment files.
```

## Prerequisites

Before you begin, ensure you have the following tools installed and configured on your local machine:

1.  **Terraform**: [Install Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.0.0 or higher recommended).
2.  **AWS CLI**: [Install and Configure AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html). Ensure your AWS credentials are configured (e.g., `aws configure`).
3.  **`kubectl`**: [Install `kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl/). Used for interacting with your Kubernetes cluster.
4.  **Basic AWS and Kubernetes Knowledge**: Familiarity with these technologies will be beneficial.

## Deployment Guide

Follow these steps sequentially to deploy the entire infrastructure, monitoring stack, and sample application.

### Step 1: Clone the Repository

First, clone this repository to your local machine:
```bash
git clone https://github.com/Berracoski/trabajo_final_buka.git
cd trabajo_final_buka
```

### Step 2: Deploy Core Infrastructure (EKS Cluster, VPC, etc.)

Navigate into the `infra` directory to deploy the foundational AWS resources, including the VPC, subnets, EKS cluster, and node groups.
```bash
cd infra/
```
Initialize Terraform:
```bash
terraform init
```

Review the planned changes (optional but recommended):
```bash
terraform plan
```
Apply the configuration to create the infrastructure. Confirm the operation by typing `yes` when prompted. **Note**: EKS cluster provisioning can take a significant amount of time (15-30 minutes).
```bash
terraform apply
```

### Step 3: Configure `kubectl` Access

Once the EKS cluster is deployed, you need to update your local `kubeconfig` file to interact with it using `kubectl`.
```bash
aws eks update-kubeconfig --region us-east-1 --name main
```


Verify that your Kubernetes nodes are in a `Ready` state:
```bash
kubectl get nodes
```

You should see your EKS worker nodes listed with a `Ready` status.

### Step 4: Deploy Monitoring Stack (Prometheus & Grafana)

Now, navigate to the `monitoring` directory to deploy Prometheus and Grafana using Terraform and Helm. This will set up comprehensive monitoring for your EKS cluster.
```bash
cd ../monitoring/
```

Initialize Terraform for the monitoring stack:
```bash
terraform init
```
Apply the monitoring configuration. Confirm by typing `yes`.
```bash
terraform apply
```

Verify that Prometheus and Grafana pods are running:
```bash
kubectl get all -n prometheus
kubectl get all -n grafana
```

You should see the pods, services, and other resources for Prometheus and Grafana active.

### Step 5: Deploy Sample Application (Nginx)

Finally, proceed to the `app-nginx` directory to deploy the sample Nginx application onto your EKS cluster.
```bash
cd ../app-nginx/
```

Initialize Terraform for the application deployment:
```bash
terraform init
```

Apply the application configuration. Confirm by typing `yes`.
```bash
terraform apply
```

Verify that the Nginx application pods are running:
```bash
kubectl get deployments -n default
kubectl get services -n default
```


Look for a deployment and service related to Nginx.

## Accessing Services

### Accessing Grafana

To access the Grafana dashboard, you'll need the external IP address of the Grafana service.

List the services in the `grafana` namespace:
```bash
kubectl get svc -n grafana
```

Locate the service named `service/grafana` and copy its `EXTERNAL-IP`. Paste this IP address into your web browser to access the Grafana login page.

## Cleanup

To avoid incurring unexpected AWS costs, it's crucial to destroy all the deployed resources once you are finished. **It's important to destroy resources in reverse order of deployment if dependencies exist, or use a top-level destroy if applicable.**

For this project, you can destroy each component from its respective directory or try to destroy from the `infra` folder, which should cascade.

**Method 1: Destroy from each folder (Recommended for safety)**

1.  **Destroy Application:**

    ```
    cd app-nginx/
    terraform destroy
    ```
2.  **Destroy Monitoring:**

    ```
    cd ../monitoring/
    terraform destroy
    ```
3.  **Destroy Infrastructure:**

    ```
    cd ../infra/
    terraform destroy
    ```

**Method 2: Destroying from `infra` (Might require manual intervention if dependencies cause issues)**

You might be able to destroy everything by running `terraform destroy` from the `infra` directory if the Terraform states are linked correctly, but sometimes cross-module dependencies (like the EKS cluster being used by `helm_release` in `monitoring` and `kubernetes_deployment` in `app-nginx`) can cause issues. If `terraform destroy` from `infra` fails, revert to Method 1.

From the root of the repository
```bash
cd infra/ # If you are not already there
terraform destroy
```


Confirm the destruction by typing `yes` when prompted for each step.

## Important Notes

-   **AWS Credentials**: Ensure your AWS credentials have sufficient permissions to create and manage EKS clusters, EC2 instances, VPC resources, and IAM roles.
-   **Deployment Time**: The initial deployment of the EKS cluster can take a considerable amount of time. Be patient.
-   **Region**: The current configuration uses `us-east-1`. If you need to deploy to a different region, you will need to update the `region` in your `provider "aws"` block within the `infra` directory.
-   **Customization**: Review the `.tf` files, `user_data.sh`, and the contents of the `app-nginx` and `monitoring` folders to adapt configurations to your specific needs.
-   **Security**: This setup provides a functional environment. For production, consider further security enhancements, such as stricter IAM policies, private EKS endpoints, and advanced network controls.

## License

This project is open-source and available under the [MIT License](LICENSE).