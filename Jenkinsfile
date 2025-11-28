pipeline {
    agent any

    environment {
        DOCKERHUB_USER = credentials('dockerhub-username')
        DOCKERHUB_TOKEN = credentials('dockerhub-token')
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/gagansingh3467-pixel/devops-fastapi-ci-cd.git'
            }
        }

        stage('Setup Python Environment') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y python3 python3-pip python3-venv

                    # Create virtualenv
                    python3 -m venv venv

                    # Install dependencies WITHOUT activation
                    venv/bin/pip install --upgrade pip
                    venv/bin/pip install -r app/requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    venv/bin/pytest -q
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t ${DOCKERHUB_USER}/devops-fastapi:jenkins -f docker/Dockerfile .
                '''
            }
        }

        stage('Docker Login') {
            steps {
                sh '''
                    echo "${DOCKERHUB_TOKEN}" | docker login -u "${DOCKERHUB_USER}" --password-stdin
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh '''
                    docker push ${DOCKERHUB_USER}/devops-fastapi:jenkins
                '''
            }
        }
    }
}

