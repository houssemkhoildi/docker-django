pipeline {
  agent any
  stages {
    stage('Jenkinsfile') {
      parallel {
        stage('Jenkinsfile') {
          steps {
            script {
              pipeline {
                agent any  // This ensures Jenkins can run this pipeline on any available agent

                environment {
                  // Define environment variables if needed
                  GITHUB_CREDENTIALS = 'your-credential-id'  // Replace with your GitHub credential ID
                }

                stages {
                  stage('Checkout') {
                    steps {
                      // Checkout your code from GitHub using the correct credentials
                      git credentialsId: "${GITHUB_CREDENTIALS}", url: 'https://github.com/houssemkhoildi/docker-django.git'
                    }
                  }

                  stage('Build Docker Image') {
                    steps {
                      script {
                        // Build your Docker image
                        sh 'docker build -t django-app .'
                      }
                    }
                  }

                  stage('Run Django App with Docker') {
                    steps {
                      script {
                        // Run your Docker container
                        sh 'docker run -d --name django-container -p 8000:8000 django-app'
                      }
                    }
                  }

                  stage('Verify Django App') {
                    steps {
                      script {
                        // Verify that the Django app is running
                        sh 'docker ps'
                        sh 'docker logs django-container'
                      }
                    }
                  }
                }

                post {
                  always {
                    // Cleanup Docker containers and images after the pipeline completes
                    sh 'docker rm -f django-container || true'
                    sh 'docker rmi django-app || true'
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