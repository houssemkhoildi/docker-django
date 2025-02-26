pipeline {
  agent any
  stages {
    stage('Jenkinsfile') {
      parallel {
        stage('Jenkinsfile') {
          steps {
            script {
              pipeline {
                agent any

                stages {
                  stage('Install Docker') {
                    steps {
                      sh '''
echo "123456" | sudo -S apt update
echo "123456" | sudo -S apt install -y docker.io
echo "123456" | sudo -S usermod -aG docker jenkins
echo "123456" | sudo -S systemctl restart jenkins
'''
                    }
                  }

                  stage('Check Docker Installation') {
                    steps {
                      sh 'docker --version'
                    }
                  }
                }
              }
            }

          }
        }

        stage('Add Docker Support') {
          steps {
            sh '''pipeline {
    agent any  // Runs on any available agent
    environment {
        PROJECT_URL = \'https://github.com/houssemkhoildi/docker-django.git\'
        IMAGE_NAME = \'django-app\'
        CONTAINER_NAME = \'django-container\'
    }
    stages {
        stage(\'Clone Repository\') {
            steps {
                echo \'Cloning the project repository from GitHub.\'
                git url: "${PROJECT_URL}", branch: \'main\'
            }
        }
        stage(\'Build Docker Image\') {
            agent {
                docker { image \'python:3.9\' }  // Build using Python 3.9 Docker image
            }
            steps {
                echo \'Building Docker image for the Django project.\'
                script {
                    // Run shell command inside the container to build the Docker image
                    sh \'docker build -t ${IMAGE_NAME} .\'
                }
            }
        }
        stage(\'Run Django App with Docker\') {
            agent {
                docker { image \'nginx\' }  // Run Django app inside an Nginx Docker container
            }
            steps {
                echo \'Running the Django app using Docker.\'
                script {
                    // Run the Django app container and expose port 8000
                    sh """
                    docker run -d --name ${CONTAINER_NAME} \\
                        -p 8000:8000 \\
                        ${IMAGE_NAME}
                    """
                }
            }
        }
        stage(\'Django Migrations\') {
            agent {
                docker { image \'python:3.9\' }  // Use Python 3.9 Docker container for Django migrations
            }
            steps {
                echo \'Running Django migrations.\'
                script {
                    // Run Django migrations inside the container
                    sh """
                    docker exec ${CONTAINER_NAME} python manage.py migrate
                    """
                }
            }
        }
        stage(\'Verify Django App\') {
            steps {
                echo \'Verifying if the Django app is running.\'
                script {
                    // Verify that the Django app is up and running by sending an HTTP request
                    sh \'curl --silent --fail http://localhost:8000 || exit 1\'
                }
            }
        }
    }
    post {
        always {
            echo \'Cleaning up Docker containers and images.\'
            script {
                // Remove the Docker container and image after use
                sh \'docker rm -f ${CONTAINER_NAME} || true\'
                sh \'docker rmi ${IMAGE_NAME} || true\'
            }
        }
    }
}
'''
            }
          }

        }
      }

    }
  }