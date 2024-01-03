# Enhanced Voting App with Docker, Kubernetes, Jenkins CI/CD, and Complete Infrastructure Automation with Terraform

This repository showcases an example of a distributed voting application running across multiple Docker containers, orchestrated with Kubernetes, automated with a Jenkins CI/CD pipeline, and optionally provisioning the entire infrastructure and components required using Terraform. It's a practical demonstration of using containerization and orchestration tools and infrastructure-as-code technologies for a microservices architecture in a cloud environment like AWS.

## Overview

The application is a simple voting platform where users can cast votes. It consists of several microservices written in different languages (Python, Node.js, .NET), demonstrating a polyglot architecture. It uses [Redis](https://redis.io/) for messaging and [Postgres](https://www.postgresql.org/) for storage. 

## Key Features (Secure Configuration Management and Provisioning of Cloud-Native Infrastructure)

- **Containerized Microservices Architecture:** The application is broken down into microservices, each running in its own Docker container. This design demonstrates a polyglot approach, using Python, Node.js, and .NET, and highlights the benefits of containerization for microservice architectures.

- **Kubernetes Orchestration and Scalability:** Deployed on Kubernetes, the app showcases sophisticated orchestration capabilities, including automated scaling, self-healing, and load balancing. It exemplifies how Kubernetes manages the lifecycle of containerized applications and maintains the desired state.

- **Advanced CI/CD Pipeline with Jenkins:** The project integrates a comprehensive Jenkins CI/CD pipeline, automating the entire process from code changes to production deployment. This includes building Docker images, pushing them to Docker Hub, and deploying updates to the Kubernetes cluster, ensuring continuous integration and delivery.

- **Infrastructure as Code with Terraform:** The entire AWS EKS environment (including security groups, VPC, EBS CSI Driver, IAM Roles and Policies, OIDC Provider, and Configuration) is provisioned using Terraform, demonstrating Infrastructure as Code (IaC) practices. This approach allows for repeatable, consistent, and efficient infrastructure provisioning and management.

- **Secure Configuration with Kubernetes Secrets:** Sensitive configurations such as database credentials are managed securely using Kubernetes Secrets. This practice aligns with security best practices in Kubernetes, ensuring the safe handling of confidential data.

- **Persistent Storage Management:** Utilizing Kubernetes PersistentVolumes (PVs) and PersistentVolumeClaims (PVCs), the application ensures data persistence for stateful services. This feature is crucial for maintaining data across pod restarts and re-deployments.

- **Load Balancing with AWS Integration:** The application leverages Kubernetes LoadBalancer services, integrated with AWS, to manage and route incoming traffic. This setup illustrates the effective use of cloud-native features, enhancing the application's accessibility and reliability.

- **AWS Cloud-Native Features:** Deployed in an AWS EKS environment, the project takes full advantage of cloud-native features like the EBS CSI driver for persistent storage, showcasing a cloud-first approach in application deployment.

These features collectively make this project a comprehensive showcase of modern application development and deployment practices, integrating containerization, orchestration, CI/CD, cloud-native technologies, and infrastructure automation.
 
## Getting Started

### Basic Prerequisites

- [Docker](https://www.docker.com/) is required as the application components are containerized. Familiarity with Docker, Docker Builds, Docker Registry, and containerization concepts is beneficial.
- [kubectl](https://kubernetes.io/docs/tasks/tools/) for interacting with your Kubernetes cluster.
- Access to a Kubernetes cluster, such as [Minikube](https://minikube.sigs.k8s.io/docs/start/) for local testing or [EKS](https://aws.amazon.com/eks/) for cloud deployment.

### Running the App with Docker Compose

1. Clone this repository.
2. Navigate to the repository directory.
3. Run the following command:
```shell
   docker compose up
```

The `vote` app will be running at [http://localhost:5000](http://localhost:5000), and the `results` will be at [http://localhost:5001](http://localhost:5001).

Alternately, if you want to run it on a [Docker Swarm](https://docs.docker.com/engine/swarm/), first make sure you have a swarm. If you don't, run:

```shell
docker swarm init
```

Once you have your swarm, in this directory run:

```shell
docker stack deploy --compose-file docker-stack.yml vote
```
## Running the App in Kubernetes

The `k8s` folder contains the YAML specifications of the Voting App's services, including LoadBalancer configurations for easy access.

### Deployment Instructions

1. Deploy the application to your Kubernetes cluster:
```shell
   kubectl apply -f k8s/
```
This will create the necessary deployments and services in your current namespace (default if not specified).

2. Once the services are deployed, Kubernetes will provision LoadBalancer endpoints for the 'vote' and 'result' web apps. You can find these endpoints by running:
```shell
kubectl get svc
```
Look for the external IP addresses or hostnames provided for the 'vote' and 'result' services. The 'vote web' app will be accessible at the LoadBalancer endpoint provided by Kubernetes (port 80 by default). The 'result' web app can be accessed similarly at its own LoadBalancer endpoint (also port 80).

##  Cleaning Up

To remove the deployed resources from your cluster, run:
```shell
kubectl delete -f k8s/
```
## Jenkins CI/CD Pipeline

This project incorporates a robust Jenkins pipeline for continuous integration and deployment, automating the lifecycle of application development from code changes to deployment in Kubernetes. The pipeline incorporates different environmental variables for easier code replication.

### Key Features of the Pipeline

- **Automated Image Builds:** Ensures that the latest version of the application is containerized.
- **Docker Hub Integration:** Seamlessly pushes images to Docker Hub, ready for deployment.
- **Dynamic Namespace Management:** Intelligently handles Kubernetes namespaces, creating them as needed.
- **Kubernetes Deployment:** Automates the deployment process to Kubernetes, making the latest version of the app always available.
- **Resource Cleanup:** Maintains a clean build environment by removing unused Docker images after the build process.

### Pipeline Multistages

- **Checkout:** Clones the latest code from the main branch of the GitHub repository.
- **Build Docker Images:** Builds Docker images for the `vote`, `result`, and `worker` components of the application.
- **Login to Docker Hub:** Authenticates with Docker Hub to enable pushing images.
- **Push Image to Docker Hub:** Pushes the newly built images to Docker Hub.
- **Check/Create Kubernetes Namespace:** Checks if the specified Kubernetes namespace exists and creates it if it doesn't.
- **Deploy to Kubernetes:** Deploys the application to Kubernetes using manifests in the `k8s` directory.
- **Post-build Cleanup:** Removes the built Docker images from the Jenkins agent to free up space.

### Prerequisites for Jenkins

- Jenkins server with Docker and Kubernetes plugins installed.
- Proper credentials configured in Jenkins for Docker Hub and Kubernetes cluster access.

### Pipeline Execution

- The pipeline is triggered by any change in the `main` branch of the GitHub repository (GitHub Webhook) or manually via the Jenkins interface.
- Each stage is clearly logged for easy tracking and troubleshooting.
- The pipeline's progress and results can be monitored in the Jenkins dashboard.

By integrating this Jenkins pipeline, the project demonstrates a practical application of CI/CD principles, ensuring that updates and new features are smoothly and reliably rolled out. This CI/CD setup ensures that the application is automatically updated in the Kubernetes cluster with each code change, making the development process more efficient and reliable.

## Terraform Infrastructure Provisioning

The `terraform` folder contains the complete Terraform configurations for provisioning and managing the entire AWS EKS (Elastic Kubernetes Service) infrastructure used by the Advanced Voting Application. It illustrates how to completely automate cloud infrastructure setup using Infrastructure as Code (IaC) principles. It also has a `Jenkinsfile` multistage pipeline that extends the root `Jenkinsfile` (adds a stage to provision the infrastructure with Terraform).

## Architecture

![Architecture diagram](architecture.excalidraw.png)

* A front-end web app in [Python](/vote) which lets you vote between two options
* A [Redis](https://hub.docker.com/_/redis/) which collects new votes
* A [.NET](/worker/) worker which consumes votes and stores them in…
* A [Postgres](https://hub.docker.com/_/postgres/) database backed by a Docker volume
* A [Node.js](/result) web app which shows the results of the voting in real time

## Notes

The voting application only accepts one vote per client browser. It does not register additional votes if a vote has already been submitted by a client.
