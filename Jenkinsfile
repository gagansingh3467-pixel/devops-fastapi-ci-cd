pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "gagansingh3467/devops-fastapi:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/gagansingh3467-pixel/devops-fastapi-ci-cd.git'
            }
        }

        stage('Set up Python venv & Install Requirements') {
            steps {
                sh '''
                    echo "Creating Python Virtual Environment..."
                    python3 -m venv venv

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
                    echo "Running tests..."
                    . venv/bin/activate
                    venv/bin/python -m pytest --disable-warnings --maxfail=1
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    docker build -t ${DOCKER_IMAGE} .
                '''
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-token',
                                                  usernameVariable: 'DOCKER_USER',
                                                  passwordVariable: 'DOCKER_PASS')]) {

                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh '''
                    echo "Pushing image to DockerHub..."
                    docker push ${DOCKER_IMAGE}
                '''
            }
        }
    }

    post {
        success {
            echo "CI/CD Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed! Check logs."
        }
    }
}

