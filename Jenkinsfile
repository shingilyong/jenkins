pipeline {
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
                    echo 'done prepare1'
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
                sh 'docker build . -t sgy12303/test:0.1'
            }
        }

        stage('push'){
            steps{
                sh 'docker push sgy12303/test:0.1'
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker run -d -p 47788:47788 --name jenkins_test sgy12303/test:0.1'
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