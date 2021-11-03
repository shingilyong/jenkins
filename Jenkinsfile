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
  - name: gradle
    image: gradle
    command:
    - sleep
    args:
    - 99d
  - name: docker
    image: docker
    command:
    - cat
    tty: true
    volumeMounts:
    - name: docker
      mountPath: /var/run/docker.sock
    - name: dockerconfigjson
      mountPath: .docker/
  volumes:
  - name: docker
    hostPath:
      path: /var/run/docker.sock
  - name: dockerconfigjson
    secret: 
      secretName: harbor-cred
      items:
      - key: ".dockerconfigjson"
        path: "config.json"
  imagePullSecrets:
  - name: harbor-cred
'''
      }
    }
  stages {
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
            container('docker') {
            sh 'docker build -t ${HARBOR_URL}/${CI_PROJECT_PATH}/${APP_NAME}:${BUILD_TAG} .'
          }
        }
}

    stage('push') {
      steps {
        container('docker'){
        sh 'docker push ${HARBOR_URL}/${CI_PROJECT_PATH}/${APP_NAME}:${BUILD_TAG}'
        sh 'docker rmi  ${HARBOR_URL}/${CI_PROJECT_PATH}/${APP_NAME}:${BUILD_TAG}'
      }
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
