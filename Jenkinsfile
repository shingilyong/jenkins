pipeline {
  environment {
    HARBOR_URL= "3.38.46.241"
    APP_NAME= "test"
    CI_PROJECT_PATH= "test"
    HARBOR_CREDENTIAL= credentials('admin')
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
  - name: helm
    image: alpine/helm
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
      mountPath: /home/ubuntu/.docker/
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
      steps {
          sh 'chmod +x gradlew'
          sh './gradlew build'
      }
    }

    stage('dockerizing') {
          steps {
            container('docker') {
            sh 'docker build -t  ${HARBOR_URL}/${CI_PROJECT_PATH}/${APP_NAME}:${BUILD_TAG} .'
          }
        }
}
    
    stage('push') {
      steps {
        container('docker'){
        sh '''echo ${HARBOR_CREDENTIAL_PSW} | docker login ${HARBOR_URL} -u admin --password-stdin'''
        sh 'docker push ${HARBOR_URL}/${CI_PROJECT_PATH}/${APP_NAME}:${BUILD_TAG}'
        sh 'docker rmi  ${HARBOR_URL}/${CI_PROJECT_PATH}/${APP_NAME}:${BUILD_TAG}'
      }
    }
}
    stage('Deploy') {
      steps {
        sh 'git clone git@github.com:shingilyong/nginx.git'
        sh 'cd nginx'
        sh 'git commit -am "application update"'
        sh 'git push'
      }
    }
   }
  }  
