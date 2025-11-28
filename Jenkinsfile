pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        IMAGE_NAME = "gagansingh3467/devops-fastapi"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/gagansingh3467-pixel/devops-fastapi-ci-cd.git'
            }
        }

        stage('Install Python & Requirements') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y python3 python3-pip
                    pip3 install -r app/requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    pip3 install pytest
                    pytest -q
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t $IMAGE_NAME:latest -f docker/Dockerfile .
                '''
            }
        }

        stage('Docker Login') {
            steps {
                sh '''
                    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh '''
                    docker push $IMAGE_NAME:latest
                '''
            }
        }
    }
}
