pipeline {
    agent any

    environment {
        GIT_BRANCH = 'main'        // Default branch
        REPOSITORY_URL = 'https://github.com/yourtechmafia/voting-app_with_CI_CD' // Default repo URL
        DOCKERHUB_CREDENTIALS = 'dockerhub_credentials'  //Your ID of Jenkins credentials for Docker Hub
        DOCKER_REGISTRY = "techmafia"
        K8s_NAMESPACE = "votingapp"    //We'll create a namespace to deploy all manifests to. Deleting just the namespace will delete all resources created.
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${env.GIT_BRANCH}",
                    url: "${env.REPOSITORY_URL}'
                echo 'Checkout complete'
            }
        }
        
        stage('Build Docker Images') {
            steps {
                script {
                    def apps = ['vote', 'result', 'worker']
                    for (app in apps) {
                        sh "docker build -t ${DOCKER_REGISTRY}/${app}:latest ./${app}"
                    }
                }
                echo 'Image Building Complete'
            }
        }
        
        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                        sh 'echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin'
                    }
                }
                echo 'Logged in to Docker Hub'
            }
        }
        
        stage('Push Image to Docker Hub') {
            steps {
                script {
                    def apps = ['vote', 'result', 'worker']
                    for (app in apps) {
                        sh "docker push ${DOCKER_REGISTRY}/${app}:latest"
                    }
                }
                echo "Pushed Images to Docker Hub"
            }
        }

        stage('Check/Create Kubernetes Namespace') {
            steps {
                script {
                    // Check if the namespace exists
                    def namespaceExists = sh(script: "kubectl get namespace ${K8s_NAMESPACE} --ignore-not-found", returnStdout: true).trim()
                    // Create the namespace if it does not exist
                    if (namespaceExists == "") {
                        echo "Creating namespace ${K8s_NAMESPACE}"
                        sh "kubectl create namespace ${K8s_NAMESPACE}"
                    } else {
                        echo "Namespace ${K8s_NAMESPACE} already exists"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "kubectl apply -f ./k8s/ --namespace=${K8s_NAMESPACE}"
                }
                echo "Deployed to Kubernetes"
            }
        }
    }

    post {
        always {
            script {
                // Clean up Docker images
                sh "docker rmi \$(docker images -q ${DOCKER_REGISTRY}/*:latest) --force"
                echo "Cleaned up Docker images"

                // Capture the output of the kubectl command
                def loadBalancerServices = sh(script: "kubectl get services --namespace ${K8s_NAMESPACE} --output wide | grep LoadBalancer", returnStdout: true).trim()

                // Echo the captured output
                echo "LoadBalancer Services in namespace ${K8s_NAMESPACE}:\n${loadBalancerServices}"
            }
            echo 'Post-build actions completed.'
        }
    }
}
