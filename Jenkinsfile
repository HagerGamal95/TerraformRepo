pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "eu-west-1"
    }

    parameters {
        booleanParam(name: 'APPLY_CHANGES', defaultValue: false, description: 'Apply Terraform changes?')
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/HagerGamal95/TerraformRepo.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-creds',
                        usernameVariable: 'CREDS_USR',
                        passwordVariable: 'CREDS_PSW'
                    )
                ]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$CREDS_USR
                        export AWS_SECRET_ACCESS_KEY=$CREDS_PSW
                        terraform init
                    '''
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-creds',
                        usernameVariable: 'CREDS_USR',
                        passwordVariable: 'CREDS_PSW'
                    )
                ]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$CREDS_USR
                        export AWS_SECRET_ACCESS_KEY=$CREDS_PSW
                        terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return params.APPLY_CHANGES == true }
            }
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-creds',
                        usernameVariable: 'CREDS_USR',
                        passwordVariable: 'CREDS_PSW'
                    )
                ]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$CREDS_USR
                        export AWS_SECRET_ACCESS_KEY=$CREDS_PSW
                        terraform apply -auto-approve tfplan
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Terraform pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs."
        }
    }
}
