pipeline {
    agent any
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'uat', 'prod'],
            description: 'Select the target environment'
        )
        choice(
            name: 'ACTION',
            choices: ['plan', 'apply'],
            description: 'Select the action to perform'
        )
        string(
            name: 'BRANCH',
            defaultValue: 'main',
            description: 'Enter the branch name to checkout'
        )
    }
    environment {
        TF_VAR_environment = "${params.ENVIRONMENT}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(
                    branches: [[name: "*/${params.BRANCH}"]],
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/payalacharya/Terraform-Automation.git']]
                )
            }
        }

        stage('Terraform Init') {
            steps {
                sh "terraform init -reconfigure"
            }
        }

        stage('Select Workspace') {
            steps {
                script {
                    def wsExists = sh(
                        script: "terraform workspace list | grep -w '${params.ENVIRONMENT}'",
                        returnStatus: true
                    ) == 0

                    if (wsExists) {
                        sh "terraform workspace select ${params.ENVIRONMENT}"
                    } else {
                        sh "terraform workspace new ${params.ENVIRONMENT}"
                    }

                    echo "✅ Active workspace: ${params.ENVIRONMENT}"
                }
            }
        }

        stage('Action') {
            steps {
                script {
                    if (params.ENVIRONMENT == 'prod' && params.ACTION in ['apply']) {
                        input message: "⚠️ You are about to ${params.ACTION.toUpperCase()} PRODUCTION. Are you sure?",
                              ok: 'Yes, proceed'
                    }

                    switch (params.ACTION) {
                        case 'plan':
                            echo "Executing Plan on ${params.ENVIRONMENT}..."
                            sh "terraform plan -var-file=envs/${params.ENVIRONMENT}.tfvars"
                            break
                        case 'apply':
                            echo "Executing Apply on ${params.ENVIRONMENT}..."
                            sh "terraform apply --auto-approve -var-file=envs/${params.ENVIRONMENT}.tfvars"
                            break
                        default:
                            error 'Unknown action'
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Terraform ${params.ACTION} on ${params.ENVIRONMENT} completed successfully."
        }
        failure {
            echo "❌ Terraform ${params.ACTION} on ${params.ENVIRONMENT} FAILED."
        }
    }
}