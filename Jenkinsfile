pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/gagansingh3467-pixel/devops-fastapi-ci-cd.git'
            }
        }

        stage('Install Python & Requirements') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y python3 python3-pip python3-venv

                    # Create virtual environment
                    python3 -m venv venv

                    # Activate venv
                    source venv/bin/activate

                    # Upgrade pip inside venv
                    pip install --upgrade pip

                    # Install project requirements
                    pip install -r app/requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    source venv/bin/activate
                    pytest -q
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t $DOCKERHUB_CREDENTIALS_USR/devops-fastapi:jenkins -f docker/Dockerfile .
                '''
            }
        }

        stage('Docker Login') {
            steps {
                sh '''
                    echo "$DOCKERHUB_CREDENTIALS_PSW" | docker login -u "$DOCKERHUB_CREDENTIALS_USR" --password-stdin
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh '''
                    docker push $DOCKERHUB_CREDENTIALS_USR/devops-fastapi:jenkins
                '''
            }
        }
    }
}

