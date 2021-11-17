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
    stage('build start') {
      agent any
      steps {
        slackSend (channel: '#general', color: '#00FF00', message: "STARTED: job '${JOB_NAME} [${BUILD_TAG}]' (${BUILD_URL})")
          }
        }
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
        git credentialsId: 'test',
            branch: 'main',
            url: 'git@github.com:shingilyong/app.git'
        sh "sed -i 's/tag:/tag: \"${BUILD_TAG}\"/g' values.yaml"
        sh "git add ."
        sh "git commit -m 'application update ${BUILD_TAG}'"
        sshagent(credentials: ['test']) {
          sh "git remote set-url origin git@github.com:shingilyong/app.git"
          sh "git push -u origin main"
      }
    }
   }
 }
  post {
    success {
      slackSend (channel: '#general', color: '#00FF00', message: "SUCCESSFUL: '${JOB_NAME} [${BUILD_TAG}]' ${BUILD_URL}")
        }
    failure {
      slackSend (channel: '#general', color: '#FF0000', message: "FAILED: '${JOB_NAME} [${BUILD_TAG}]' ${BUILD_URL}")    
        }
   }
 }  

