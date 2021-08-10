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
                sh  './demo/gradlew build'


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
                echo 'docker build . -t ci/test'
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