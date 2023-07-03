#!/usr/bin/env groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "eu-west-1"
        ANSIBLE_VAULT_PASSWORD_FILE = credentials('ANSIBLE_VAULT_PASSWORD_FILE')
        TF_VAR_db_user = credentials ('TF_VAR_db_user')
        TF_VAR_db_password = credentials ('TF_VAR_db_password')
        TF_VAR_email = credentials('TF_VAR_email')
    }
    stages {
        stage("Create Cluster With Prometheus and Grafana") {
            steps {
                script {
                    dir("provision") {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
             }
            options {
                timeout(time: 20, unit: 'MINUTES')
            }
        }
        stage("Install Let'sEncrypt Certificate") {
            steps {
                script {
                    dir("ssl") {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
		options {
                    retry(3)
		}
        }
        stage("Deploy App") {
            steps {
                script {
                    dir("deploy") {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
    }
}


