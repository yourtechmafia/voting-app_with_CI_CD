# Enhanced Voting App with Docker, Kubernetes, and CI/CD

This repository showcases an example of a distributed voting application running across multiple Docker containers, orchestrated with Kubernetes, and automated with a Jenkins CI/CD pipeline. It's a practical demonstration of using containerization and orchestration technologies for a microservices architecture.

## Overview

The application is a simple voting platform where users can cast votes. It consists of several microservices written in different languages (Python, Node.js, .NET), demonstrating a polyglot architecture. It uses Redis for messaging and Postgres for storage. 

## Key Features

- **Containerized Microservices:** Each component of the application runs in its own Docker container.
- **Kubernetes Orchestration:** The app is deployed on a Kubernetes cluster, showcasing pod management, service discovery, and scalability.
- **CI/CD Pipeline:** Automated build and deployment using Jenkins, including pushing Docker images to Docker Hub and deploying to Kubernetes.
- **Cloud-Native Integration:** Deployed on an EKS cluster with considerations for cloud-specific features like EBS CSI driver.
- **Persistent Storage with PVC and PV:** The application leverages Kubernetes PersistentVolumes (PVs) and PersistentVolumeClaims (PVCs) for efficient and reliable data storage. This ensures data persistence for stateful components like the Postgres database, allowing for data retention across pod restarts and deployments.
- **Load Balancing:** Utilizes Kubernetes LoadBalancer services to manage incoming traffic.

## Getting Started

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop) for container management.
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

The project is integrated with a Jenkins pipeline for continuous integration and continuous deployment (CI/CD), automating the process of building, testing, and deploying the application.

### Pipeline Overview

- **Build Stage:** Jenkins builds Docker images for each component of the application (`vote`, `result`, and `worker`).
- **Push Stage:** The built images are pushed to a Docker registry (Docker Hub).
- **Deploy Stage:** Jenkins applies the Kubernetes manifests from the `k8s` directory to deploy the application to the cluster.

### Running the Pipeline

- Trigger the pipeline by making a change in the GitHub repository (GitHub Webhook) or manually via the Jenkins interface.
- The pipeline's progress and results can be monitored in the Jenkins dashboard.

### Prerequisites for Jenkins

- Jenkins server with Docker and Kubernetes plugins installed.
- Proper credentials configured in Jenkins for Docker Hub and Kubernetes cluster access.

This CI/CD setup ensures that the application is automatically updated in the Kubernetes cluster with each code change, making the development process more efficient and reliable.


## Architecture

![Architecture diagram](architecture.excalidraw.png)

* A front-end web app in [Python](/vote) which lets you vote between two options
* A [Redis](https://hub.docker.com/_/redis/) which collects new votes
* A [.NET](/worker/) worker which consumes votes and stores them in…
* A [Postgres](https://hub.docker.com/_/postgres/) database backed by a Docker volume
* A [Node.js](/result) web app which shows the results of the voting in real time

## Notes

The voting application only accepts one vote per client browser. It does not register additional votes if a vote has already been submitted from a client.
