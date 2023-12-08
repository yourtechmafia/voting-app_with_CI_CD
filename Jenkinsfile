pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
        REGISTRY = "techmafia"
        NAMESPACE = "votingapp"
    }

    stages {
        stage('Build Docker Images') {
            steps {
                script {
                    def apps = ['vote', 'result', 'worker']
                    for (app in apps) {
                        sh "docker build -t ${REGISTRY}/${app}:latest ./${app}"
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
                        def apps = ['vote', 'result', 'worker']
                        for (app in apps) {
                            def image = docker.image("${REGISTRY}/${app}:latest")
                            image.push()
                        }
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "kubectl apply -f ./k8s/ --namespace=${NAMESPACE}"
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker images
            sh "docker rmi \$(docker images -q ${REGISTRY}/*:latest) --force"
            echo 'Post-build actions completed.'
        }
    }
}
