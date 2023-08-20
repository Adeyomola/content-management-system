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
        TF_VAR_db_user_d = credentials ('TF_VAR_db_user_d')
        TF_VAR_db_password_d = credentials ('TF_VAR_db_password_d')
        TF_VAR_db_name = credentials ('TF_VAR_db_name')
        TF_VAR_db_port = credentials ('TF_VAR_db_port')
        TF_VAR_arn = credentials ('TF_VAR_arn')
        TF_VAR_email = credentials('TF_VAR_email')
        TF_VAR_account_id = credentials('TF_VAR_account_id')
	DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }
    stages {
        stage("Docker Image Build") {
            steps {
                script {
                    sh "sudo docker build . -t wp"
                }
             }
        }
        stage("Docker Image Push") {
            steps {
                script {
		    sh "echo $DOCKERHUB_CREDENTIALS_PSW | sudo docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                    sh "sudo docker tag wp adeyomola/wordpress"
		    sh "sudo docker push adeyomola/wordpress"
                }
             }
        }
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
        stage("Convert Template Files") {
            steps {
                script {
                    dir("ansible") {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
        stage("Ingress Controller") {
            steps {
                script {
                    dir("alb") {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
//        stage("Deploy DB") {
//           steps {
//                script {
//                    dir("rds") {
//                        sh "terraform init"
//                        sh "terraform apply -auto-approve"
//                    }
//                }
//            }
//        }
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
    post {
      always {
        sh 'docker logout'
        }
    }
}


