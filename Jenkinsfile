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
                sh 'docker build . -t ci/test'
            }
        }

        stage('push'){
            steps{
                sh 'docker login https://3.35.140.37/ -u admin -p admin'
                sh 'docker push 3.35.140.37/hello'
            }
        }

        stage('Deploy') {
            steps {
                echo 'docker run -d -p 47788:47788 --name ci_test ci/test'
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