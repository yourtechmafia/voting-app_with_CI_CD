# Terraform Configuration for EKS Infrastructure

This directory contains the Terraform configurations for provisioning and managing the AWS EKS (Elastic Kubernetes Service) infrastructure used by the Advanced Voting Application. It illustrates how to completely automate cloud infrastructure setup using Infrastructure as Code (IaC) principles.

## Overview

The Terraform scripts in this directory are designed to create a fully functioning AWS EKS cluster, complete with all necessary components, including VPC, subnets, IAM roles, security groups, etc. This setup demonstrates a practical implementation of a cloud-native Kubernetes environment.

## Prerequisites

To effectively use and understand the Terraform configurations in this directory, the following prerequisites are necessary:

- **Basic AWS Knowledge:** Familiarity with AWS services such as EKS, EC2, IAM, VPC, SG, and EBS is essential to understand the infrastructure components being provisioned.
- **AWS Account and CLI:** Access to an AWS account and configure AWS CLI (`aws configure`) on your machine or instance.
- **Terraform CLI:** Install Terraform to automate the provisioning of the cloud infrastructure.
- **Docker:** Docker is required as the application components are containerized. Familiarity with Docker, Docker Builds, Docker Registry, and containerization concepts is beneficial.
- **Jenkins (Optional):** A Jenkins server setup is optional for the CI/CD pipeline. It should have the necessary plugins and permissions to handle AWS interactions, Docker builds, and Terraform scripts.

## Configuration Details

- `variables.tf`: Defines variables for customizing AWS resources.
- `provider.tf`: Configures the Terraform provider for AWS.
- `vpc.tf`: Sets up the VPC and related networking resources.
- `security-groups.tf`: Creates security groups for the EKS cluster.
- `iam.tf`: Manages IAM roles and policies required for EKS and other services.
- `eks-cluster.tf`: Main configuration for the AWS EKS cluster.
- `eks-nodes.tf`: Defines the EKS worker nodes setup.
- `ebs-csi-driver.tf`: Sets up the EBS CSI driver for Kubernetes persistent storage.
- `ebs-csi-iam-role.tf`: IAM roles for the EBS CSI driver.
- `oidc-provider.tf`: Configures OIDC provider for EKS.
- `outputs.tf`: Specifies output variables post Terraform execution.

### `get-thumbprint.sh` Script and Its Role in OIDC Configuration

- **Purpose:** The `get-thumbprint.sh` script is a crucial part of setting up the OIDC (OpenID Connect) provider for AWS EKS within the Terraform configuration. OIDC is a critical component in EKS for identity federation between AWS IAM and Kubernetes, which enhances security and streamlines access management.

- **Functionality:** This script retrieves the thumbprint of the OIDC provider's SSL certificate. The thumbprint is a security feature that uniquely identifies the SSL certificate, ensuring that communications with the OIDC endpoint are secure and trusted. The script fetches this thumbprint by making an HTTPS request to the OIDC endpoint and extracting the certificate details to obtain the thumbprint.

- **Usage in `oidc-provider.tf`:** After Terraform provisions the EKS cluster, `oidc-provider.tf` automatically executes this script to dynamically fetch the thumbprint required for the OIDC identity provider's creation. In this file (`oidc-provider.tf`), the script's output (the thumbprint) is utilized to set up the OIDC identity provider in AWS correctly. This setup is essential for establishing a trust relationship between AWS IAM and the Kubernetes service accounts, which in turn is vital for the EBS CSI driver to function correctly.

- **Importance for EBS CSI Driver, IAM Roles, and Persistent Storage Management:** The OIDC provider and the corresponding thumbprint are critical for enabling IAM Roles for Service Accounts (IRSA) in EKS. This functionality is particularly important for the AWS EBS CSI driver, which allows EKS to manage EBS volumes for persistent storage efficiently. The CSI driver uses IAM roles associated with Kubernetes service accounts, relying on OIDC for secure and seamless authentication and authorization with AWS services. Remember, our deployment utilizes Kubernetes PersistentVolumes (PVs) and PersistentVolumeClaims (PVCs) to ensure data persistence for stateful services. This feature is crucial for maintaining data across pod restarts and re-deployments.

Including this script in our Terraform setup demonstrates a comprehensive approach to cloud-native security and identity management, ensuring that the Kubernetes cluster not only functions optimally with services like the EBS CSI driver but also aligns with best practices in identity access management and automation.

## Initialization and Usage

1. **Initialization:**
   Navigate to this directory and run `terraform init`. This command initializes Terraform, downloads necessary providers, and sets up the backend for state management.

2. **Planning:**
   Run `terraform plan` to preview the changes that Terraform will perform to your AWS infrastructure.

3. **Applying:**
   Execute `terraform apply` to provision the resources defined in the Terraform configuration files. This command will create the EKS cluster along with the necessary networking and security components.

4. **Cleanup:**
   When you no longer need the infrastructure, you can run `terraform destroy` to remove all resources created by Terraform.

## Notes

- Review and customize the variable values in `variables.tf` as per your requirements.
- Be mindful of AWS costs associated with the resources being created by these scripts.
- Always destroy your Terraform-managed infrastructure when it's no longer needed to avoid unnecessary charges.
- Ensure Jenkins has the necessary plugins and permissions to execute Terraform scripts and interact with AWS.

By leveraging Terraform in conjunction with Jenkins, this project demonstrates an automated, reproducible, and scalable approach to cloud infrastructure management, essential for modern cloud-native applications.

## The Multi-Stage Jenkins Pipeline

This project includes a sophisticated multi-stage Jenkins pipeline that integrates seamlessly with the Terraform configurations for infrastructure provisioning. It includes several critical stages that automate the deployment of the application from code to a Kubernetes cluster in AWS.

This Jenkinsfile is an addition to the root `Jenkinsfile`. It only adds the `Provision AWS EKS Environment with Terraform` stage.

Extra highlights of the pipeline:

- **Terraform Integration:** A dedicated pipeline stage utilizes Terraform to provision and manage the AWS EKS cluster and associated resources. This stage automatically sets up the entire cloud environment needed for the application.
- **Kubernetes Deployment:** Post infrastructure setup, the pipeline deploys the application onto the provisioned Kubernetes cluster, demonstrating end-to-end automation from code to cloud deployment.

Here's an overview of the critical stages:

### Provisioning AWS EKS Environment with Terraform

- **Terraform Initialization and Application:** In this stage, the pipeline changes the directory to the `terraform` folder and runs `terraform init` to initialize the Terraform environment. It then executes `terraform apply -auto-approve` to provision the AWS EKS cluster along with all necessary infrastructure components as defined in the Terraform files. This includes the setup of VPC, subnets, IAM roles, and security groups.

- **Cluster Configuration:** After the infrastructure is provisioned, the pipeline fetches the EKS cluster name using `terraform output cluster_name` and updates the `kubeconfig` file on the Jenkins server. This enables `kubectl` commands to interact with the newly created EKS cluster.

### Checking/Creating Kubernetes Namespace

- **Namespace Verification:** This stage checks if the specified Kubernetes namespace (defined in `K8s_NAMESPACE`) exists in the cluster. If the namespace does not exist, it is created. This ensures that the application components are deployed in the correct namespace, providing an organized and isolated environment within the Kubernetes cluster.

### Deploying to the Kubernetes Namespace

- **Application Deployment:** In this stage, the pipeline deploys the application to the Kubernetes cluster using `kubectl apply -f ./k8s/ --namespace=${K8s_NAMESPACE}`. It applies all Kubernetes manifests found in the `k8s` root directory of this repository to the previously created or verified namespace. This results in the deployment of the application components, including services, deployments, and any other Kubernetes resources defined in the manifests.

These stages collectively demonstrate a powerful, automated process for cloud infrastructure provisioning and application deployment, showcasing advanced CI/CD practices and cloud-native orchestration.

This Terraform setup is part of the Advanced Voting Application project, showcasing a modern approach to automating cloud infrastructure for containerized applications.
