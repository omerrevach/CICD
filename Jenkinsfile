pipeline { 
    agent {
        docker {
            label 'agent1'
            image "rebachi/bank-leumi:agent"
            args '-u 0:0 -v /var/run/docker.sock:/var/run/docker.sock'
            alwaysPull true
        }
    } 

    environment {
        registry = "rebachi/bank-leumi"
        registryCredential = 'docker-hub-id-new'
    }

    stages {
        stage('Checkout scm') { 
            steps { 
                checkout scm
            }
        }
        stage('Parallel Stages For Static Analysis Tests'){
            parallel {
                stage("Pylint") {
                    steps {
                        sh 'pylint --output-format=parseable --fail-under=5 ./app/app.py'
                    }
                }

                stage("Bandit Scan") {
                    steps {
                        sh 'bandit -r ./app'
                    }
                }
            }
        }

        stage("Docker Build") {
            steps {
                script {
                    app = docker.build("${registry}:${env.BUILD_NUMBER}", "./app")
                }
            }
        }

        stage("Docker Push") {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        app.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }

        stage("Trigger CD Job") {
            steps {
                script {
                    build job: 'CD',
                        parameters: [
                            string(name: 'DOCKER_IMAGE', value: "${registry}:${env.BUILD_NUMBER}")
                        ]
                }
            }
        }
    }

    post {
        cleanup {
            steps {
                script {
                    sh 'docker rmi ${registry}:${env.BUILD_NUMBER} || true'
                }
            }
        }
    }
}
