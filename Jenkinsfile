#!/usr/bin/env groovy
pipeline {
    agent any
//    agent {
//	label 'agent1'
//    }
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "eu-west-1"
        ANSIBLE_VAULT_PASSWORD_FILE = credentials('ANSIBLE_VAULT_PASSWORD_FILE')
        TF_VAR_db_user = credentials ('TF_VAR_db_user')
        TF_VAR_db_password = credentials ('TF_VAR_db_password')
        TF_VAR_db_name = credentials ('TF_VAR_db_name')
        TF_VAR_db_port = credentials ('TF_VAR_db_port')
        TF_VAR_arn = credentials ('TF_VAR_arn')
        TF_VAR_email = credentials('TF_VAR_email')
        TF_VAR_account_id = credentials('TF_VAR_account_id')
    }
    stages {
        stage('Static Application Security Testing - SonarQube') {
          steps {
            withSonarQubeEnv(installationName: "sq1") {
              script {
                def scannerHome = tool 'sonarscanner';
                sh "${scannerHome}/bin/sonar-scanner"
              }
            }
          }
        }
//        stage("Quality Gate") {
//            steps {
//              timeout(time:2, unit: "MINUTES") {
//                waitForQualityGate abortPipeline: true
//               }
//            }
//        }
        stage("Docker Image Build") {
            steps {
                script {
                    dir("docker") {
                        sh "docker build . -t wp"
                    }
                 }
             }
        }
        stage("Docker Image Push") {
            steps {
              withCredentials ([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerhubPassword', usernameVariable: 'dockerhubUser')]) {
                script {
                    dir("docker") {
		        sh "echo ${env.dockerhubPassword} | docker login -u ${env.dockerhubUser} --password-stdin"
                        sh "docker tag wp adeyomola/wordpress"
		        sh "docker push adeyomola/wordpress"
			sh "docker logout"
                    }
                 }
	       }
            }
        }
        stage("Create EKS Cluster") {
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
        stage("Install Let'sEncrypt SSL Certificate") {
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
        stage("Deploy Ingress Controller") {
            steps {
                script {
                    dir("alb") {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
        stage("Deploy Prometheus and Grafana for Monitoring") {
            steps {
                script {
                    dir("monitoring") {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
        stage("Deploy ELK Stack for Logging") {
            steps {
                script {
                    dir("logging") {
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
        stage("Scan Image") {
            steps {
                script {
                        sh "trivy image adeyomola/wordpress"
//			sh "trivy --exit-code 1 --no-progress --severity CRITICAL adeyomola/wordpress"
                 }
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


