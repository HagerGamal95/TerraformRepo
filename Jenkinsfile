pipeline {
    agent any

    options {
        // Don’t try to resume Terraform steps after Jenkins restarts
        disableResume()
    }

    environment {
        AWS_DEFAULT_REGION = "eu-west-1"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/maatoot/terraform-nginx.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh 'terraform apply -auto-approve -input=false'
                }
            }
        }

        stage('Wait for Nginx') {
            steps {
                // creds not strictly required here, بس خاليها موحدة
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    script {
                        def ip = sh(
                            script: "terraform output -raw instance_public_ip",
                            returnStdout: true
                        ).trim()

                        sh """
                            echo 'Waiting for Nginx on ${ip}...'
                            until curl -s http://${ip} >/dev/null 2>&1; do
                              sleep 10
                            done
                            echo 'Nginx is up and running by hager Gamal on ${ip}!'
                        """
                    }
                }
            }
        }
    }
}
