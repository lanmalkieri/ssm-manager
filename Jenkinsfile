#!groovy

pipeline {
    agent none

    options {
        timestamps()
        timeout(time: 15, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    parameters {
        booleanParam(description: 'Production Environment', defaultValue: false, name: 'production')
    }

    stages {
        stage('Update configs for dev account') {
            agent { node { label 'linux' } }

            when { not { expression { params.production } } }

            steps {
                ansiColor('xterm') {
                    sh "./ssm-wrapper.sh dev"
                }
            }
            post {
                always {
                    cleanWs()
                }
            }
        }
        stage('Update configs for prod account') {
            agent { node { label 'linux' } }

            when { expression { params.production } }

            steps {
                ansiColor('xterm') {
                    sh "./ssm-wrapper.sh prod"
                }
            }
            post {
                always {
                    cleanWs()
                }
            }
        }
    }
}


