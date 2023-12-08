pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub_credentials'  //Your ID of Jenkins credentials for Docker Hub
        REGISTRY = "techmafia"
        NAMESPACE = "votingapp"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/yourtechmafia/voting-app_with_CI_CD'
                echo 'Checkout complete'
            }
        }
        
        stage('Build Docker Images') {
            steps {
                script {
                    def apps = ['vote', 'result', 'worker']
                    for (app in apps) {
                        sh "docker build -t ${REGISTRY}/${app}:latest ./${app}"
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
                        sh "docker push ${REGISTRY}/${app}:latest"
                    }
                }
                echo "Pushed Images to Docker Hub"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "kubectl apply -f ./k8s/ --namespace=${NAMESPACE}"
                }
                echo "Deployed to Kubernetes"
            }
        }
    }

    post {
        always {
            steps {
                script {
                    // Clean up Docker images
                    sh "docker rmi \$(docker images -q ${REGISTRY}/*:latest) --force"
                    echo "Cleaned up Docker images"
                    // Capture the output of the kubectl command
                    def loadBalancerServices = sh(script: "kubectl get services --namespace ${NAMESPACE} --output wide | grep LoadBalancer", returnStdout: true).trim()
                    // Echo the captured output
                    echo "LoadBalancer Services in namespace ${NAMESPACE}:\n${loadBalancerServices}"
                }
                echo 'Post-build actions completed.'
            }
        }
    }
}
