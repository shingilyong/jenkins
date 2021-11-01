pipeline {
  agent any
  stages {
    stage('Prepare') {
      agent any
      post {
        success {
          echo 'prepare success'
        }

        always {
          echo 'done prepare'
        }

        cleanup {
          echo 'after all other post conditions'
        }

      }
      steps {
        checkout scm
      }
    }

    stage('build gradle') {
      post {
        success {
          echo 'gradle build succss'
        }

        failure {
          echo 'gradle build failed'
        }

      }
      steps {
        sh 'chmod +x gradlew'
        sh './gradlew build'
        sh 'ls -al ./build'
      }
    }

    stage('dockerizing') {
      parallel {
        stage('dockerizing1') {
          steps {
            sh 'sudo chmod 666 /var/run/docker.sock'
            sh 'docker build . -t ${registry}:${tag}'
          }
        }

        stage('ls -la') {
          steps {
            sh 'ls -la'
          }
        }

      }
    }

    stage('push') {
      steps {

        sh 'docker push ${registry}:${tag}'
        sh 'docker rmi ${registry}:${tag}'
      }
    }

    stage('Deploy') {
      post {
        success {
          echo 'success'
        }

        failure {
          echo 'failed'
        }

      }
      steps {
        echo 'success'
      }
    }

  }
  environment {
    registry = 'sgy12303/test'
    tag = 'latest'
  }
}
