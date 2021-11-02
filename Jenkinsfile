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
  - name: kaniko
    image: pull hellojukay/kaniko-project-executor:debug
    command:
    - sleep
    args:
    - 99d

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
            sh '/kaniko/executor --context ./ --dockerfile ./dockerfile --destination $HARBOR_URL/$CI_PROJECT_PATH/$APP_NAME:$BUILD_TAG'
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
