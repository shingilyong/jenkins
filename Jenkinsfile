pipeline {
  environment {
    HARBOR_URL= "3.38.46.241"
    APP_NAME= "test"
    CI_PROJECT_PATH= "test"
    }
  agent {
    kubernetes {
      yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: docker
    image: docker:20.10.10
    command:
    - cat
    tty: true
'''
      }
    }
  stages {
    stage('Prepare') {
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
      }
    }

    stage('dockerizing') {
          steps {
            sh 'docker build  -t ${HARBOR_URL}:${BUILD_TAG} .'
          }
        }


    stage('push') {
      steps {

        sh 'docker push ${HARBOR_URL}:${BUild_TAG}'
        sh 'docker rmi ${HARBOR_URL}:${BUILD_TAG}'
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
  }  
