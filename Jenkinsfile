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