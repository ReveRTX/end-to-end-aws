pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {
        stage ('Initialize Terraform'){
            steps {
                sh 'terraform init'
            }
        }

        stage ('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage ('Terraform Apply') {
            steps {
                sh 'terraform -auto-apply'
            }
        }

        stage ('Sleep for 3 minutes') {
            steps {
                sh 'sleep 3m'
            }
        }

        stage ('Destroy all the resources') {
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}