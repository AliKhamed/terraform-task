pipeline {
    agent any

        stages {

            stage('terraform init') {
                steps {
                    withAWS(credentials: 'aws', region: 'us-east-1'){
                    sh 'terraform init '}
                }
            }

            stage('terraform apply') {
                steps {
                    withAWS(credentials: 'aws', region: 'us-east-1'){
                    sh 'terraform apply --auto-approve -no-color '}
                    }
            }

            stage('installing slave packages using ansible') {
                steps {
                    withAWS(credentials: 'aws', region: 'us-east-1'){
                    sh 'ansible-playbook -i /var/jenkins_home/hosts ./ansible/slave-ansible.yaml'}
                    }
            }


            stage('installing docker inside the slave using ansible') {
                steps {
                    withAWS(credentials: 'aws', region: 'us-east-1'){
                    sh 'ansible-playbook -i /var/jenkins_home/hosts ./ansible/docker-ansible.yaml'}
                    }
            }

            stage('copy jar file for slave communication') {
                steps {
                    withAWS(credentials: 'aws', region: 'us-east-1'){
                    sh 'ansible-playbook -i /var/jenkins_home/hosts jar.yaml'}
                    }
            }

            stage('clone / build / run app inside EC2 slave') {
                agent { node { label 'terraform-slave'} }
                environment {
                    
                    rds_hostname   = '$(aws ssm get-parameter --name /dev/database/endpoint --query "Parameter.Value" --with-decryption --output text)'
                    rds_username   = '$(aws ssm get-parameter --name /dev/database/username --query "Parameter.Value" --with-decryption --output text)'
                    rds_password   = '$(aws ssm get-parameter --name /dev/database/password --query "Parameter.Value" --with-decryption --output text)'
                    rds_port       = 3306
                    
                    redis_hostname = '$(aws ssm get-parameter --name /dev/redis/endpoint --query "Parameter.Value" --with-decryption --output text)'
                    redis_port = 6379

                }
                steps {
                    git url:'https://github.com/mahmoud254/jenkins_nodejs_example.git' , branch: 'rds_redis'
                    withAWS(credentials: 'aws', region: 'us-east-1'){
                       sh """
                        sudo apt install -y awscli 
                        sudo chmod 666 /var/run/docker.sock
                        sudo usermod -aG docker ubuntu
                        docker build -f dockerfile -t app-image .
                        docker run -d -p 3000:3000 --name node-app -e RDS_HOSTNAME=${rds_hostname} -e RDS_USERNAME=${rds_username}'rizk' -e RDS_PASSWORD=${rds_password} -e RDS_PORT=${rds_port} -e REDIS_HOSTNAME=${redis_hostname} -e REDIS_PORT=${redis_port} app-image
                        """
                    }
                }
            }

            // stage('terraform destroy') {
            //     steps {
            //         withAWS(credentials: 'aws', region: 'us-east-1'){
            //         sh 'terraform destroy --auto-approve -no-color '}
            //         }
            // }
        }
        
    }