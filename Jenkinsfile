pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = credentials('dockerhub-username')
        DOCKERHUB_PASSWORD = credentials('dockerhub-password')
        APP_NAME = "devops-fastapi"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/gagansingh3467-pixel/devops-fastapi-ci-cd.git'
            }
        }

        stage('Setup Python 3.10 + Virtualenv') {
            steps {
                sh '''
                    echo "Using python3.10..."
                    python3.10 --version

                    echo "Creating virtual environment..."
                    python3.10 -m venv venv

                    echo "Activating venv..."
                    . venv/bin/activate

                    echo "Upgrading pip..."
                    venv/bin/pip install --upgrade pip

                    echo "Installing requirements..."
                    venv/bin/pip install -r app/requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    echo "Running Pytest..."
                    . venv/bin/activate
                    venv/bin/pytest -q || true
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    docker build -t $DOCKERHUB_USERNAME/$APP_NAME:$IMAGE_TAG .
                '''
            }
        }

        stage('Docker Login') {
            steps {
                sh '''
                    echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh '''
                    echo "Pushing Docker image to DockerHub..."
                    docker push $DOCKERHUB_USERNAME/$APP_NAME:$IMAGE_TAG
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline SUCCESS — Docker image pushed!"
        }
        failure {
            echo "Pipeline FAILED — check logs."
        }
    }
}

