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

                environment {
                  // Define environment variables
                  DOCKER_IMAGE = 'your-dockerhub-username/django-app'
                  APP_NAME = 'django-app'
                }

                stages {
                  stage('Checkout') {
                    steps {
                      echo 'Checking out code...'
                      git 'https://github.com/<your-repo-url>.git' // Replace with your repository URL
                    }
                  }

                  stage('Build') {
                    steps {
                      echo 'Building Docker image...'
                      sh 'docker build -t $DOCKER_IMAGE .'
                    }
                  }

                  stage('Test') {
                    steps {
                      echo 'Running tests...'
                      // Example: Run Django tests inside the container
                      sh 'docker run --rm $DOCKER_IMAGE python manage.py test'
                    }
                  }

                  stage('Push Image') {
                    steps {
                      echo 'Pushing Docker image to registry...'
                      withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh """
                        docker login -u $USERNAME -p $PASSWORD
                        docker tag $DOCKER_IMAGE $DOCKER_IMAGE:latest
                        docker push $DOCKER_IMAGE:latest
                        """
                      }
                    }
                  }

                  stage('Deploy') {
                    steps {
                      echo 'Deploying the application...'
                      script {
                        if (env.BRANCH_NAME == 'main') {
                          // Example: Deploy to Kubernetes
                          sh 'kubectl apply -f k8s/deployment.yaml'
                        } else {
                          echo 'Skipping deployment for non-main branches.'
                        }
                      }
                    }
                  }
                }

                post {
                  success {
                    echo 'Pipeline completed successfully!'
                  }
                  failure {
                    echo 'Pipeline failed. Check logs for details.'
                  }
                }
              }
            }

          }
        }

        stage('Add Docker Support') {
          steps {
            sh '''sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins'''
          }
        }

      }
    }

  }
}