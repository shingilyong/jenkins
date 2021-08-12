pipeline {
    environment {
        registry = "sgy12303/test"
        tag = "latest"
    }
    agent any


    stages {
        stage('Prepare') {
            agent any

            steps {
                checkout scm
            }

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
        }


        stage('build gradle') {
            steps {
                sh 'chmod +x gradlew'
                sh  './gradlew build'
                sh 'ls -al ./build'
            }
            post {
                success {
                    echo 'gradle build success'
                }

                failure {
                    echo 'gradle build failed'
                }
            }
        }

        stage('dockerizing'){
            steps{
                sh 'docker build . -t ${registry}:${tag}'
            }
        }

        stage('push'){
            steps{
                sh 'docker push ${registry}:${tag}'
                sh 'docker rmi ${registry}:${tag}'
            }
        }

        stage('Deploy') {
            steps {
                sh 'git remote add odd git@github.com:shingilyong/k8s.git'
                sh 'git config --global user.email "sgy12303@gmail.com"'
                sh 'git add .'
                sh 'git commit -m "test"'
                sh 'git push original master'
            }

            post {
                success {
                    echo 'success'
                }

                failure {
                    echo 'failed'
                }
            }
        }
    }
}