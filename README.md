# CI/CD Nodejs Application using Terraform - Jenkins - Ansible
Terraform Task using AWS Services

### More about the project
* Tech Stack
  - Terraform for Infrastucture as code (IaC) in AWS Cloud
  - Jenkins for pipeline
  - Ansible for Configuration Management inside the infrastructure 

### Introduction 
Build an AWS architecture with terraform to run nodeJS application using CI/CD Jenkins Pipeline, the architecture has the following:
  * Provider: ( for the backend using s3 bucket to host tfstate file)
  * Network: ( One VPC with 2 public subnets and 2 private subnets, nat gateway, internet gateway, route tables with their associations)
  * EC2: (Bastion server and Private instance for application)
  * Security groups: ( Allowing the following ports: 22, 3000, 3306, 6379, 80 )
  * Private key for EC2 (using tls and key pair resources)
  * Secret Manager: (To save EC2 private key in secure place in for utilization purposes)
  * RDS: ( Application Database)
  * Elastic Cache: (IN-Memory database)
  * System Manager: (Host environment Variables for Redis and RDS)
  

### Steps to go live
1- Before Creating Pipeline you have to install the following:
  * AWS Steps : for aws credentials
  * Docker inside your Jenkins (Make sure that you have installed docker daemon )
  * Ansible inside Jenkins (i installed it inside the jenkins machine/container itself)   --> [link](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
  * Terraform inside Jenkins (i installed it inside the jenkins machine/container itself) --> [link](https://www.terraform.io/downloads)
  
2- Create your Jenkins pipeline, mention assigned repo:
  ![image](https://user-images.githubusercontent.com/30655799/181934660-c367a350-bc53-4eb9-8ac6-3d4c1b67efa2.png)
  
3- Build the pipeline to fetch Jenkinsfile and begin the stages installation
  ![image](https://user-images.githubusercontent.com/30655799/181935047-313db1a9-4730-4d2e-a08f-7f6c9e7f47a6.png)


### Configuration 
1- Create Ansible scripts for to configure Application EC2 (Private-EC2) 
2- configure ansible to run over private ips through bastion (~/.ssh/config):
  * In order to do this we used the Jumphost concept as we want to ssh from jenkins directly to private ec2 which in our archecture is locked from any device except bastion-ec2 so we have to find away to ssh from jenkins server directly to private-vm
  * So we create a config file inside /root/.ssh using terraform local_file resource
  * Result:
  
  ![image](https://user-images.githubusercontent.com/30655799/181935559-80651ca0-06d4-4d13-b628-95990f568fb4.png)

  ![image](https://user-images.githubusercontent.com/30655799/181935328-33493bee-9378-425a-836a-6413d3b3f1cd.png)
  
  
3- Configure EC2 Private-VM as Jenkins slave
  * After successfully configured the jumphost and ssh from Jenkins machine to private EC2 we need to set it up as Jenkins slave to run it in the pipeline for future builds
  * First we have to setup docker and copy the jar file from jenkins to private EC2 (you will find them in docker-ansible.yaml / jar.yaml)
  * go inside Jenkins -> manage Nodes --> New node --> configure it based on command on the controller
```bash
ssh <machine> java -jar <where-you-set-jar-file>
```
 ![image](https://user-images.githubusercontent.com/30655799/181935799-366357b7-4cc2-4933-913c-9431e048fc1c.png)
 
* Results
![image](https://user-images.githubusercontent.com/30655799/181935862-4a51714d-a400-4ee7-b6fb-39a0cd3cb643.png)

4- create pipeline to deploy nodejs_example from branch (rds_redis) --> [link](https://github.com/mahmoud254/jenkins_nodejs_example/tree/rds_redis):
  * Using plugin git insied Jenkinsfile we can clone directly the repo inside private-vm
  * Install awscli for using environment stored in System manager like hostname, password, username
  * Get access to docker deamon
  * Set ec2 user "ubuntu" inside docker group 
  * Build the image from the repo
  * Run container based on this image with the suitable environment variables 
```yaml
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
                docker run -d -p 3000:3000 --name node-app -e RDS_HOSTNAME=${rds_hostname} -e RDS_USERNAME=${rds_username}'rizk' -e RDS_PASSWORD=${rds_password} -e RDS_PORT=${rds_port} -e REDIS_HOSTNAME=${redis_hostname} -e REDIS_PORT=${redis_port} app-image"""
              }
      }
}
```

5- Create Loadbalancer linked to private-vm and test your application by calling loadbalancer_url/db and /redis:

![image](https://user-images.githubusercontent.com/30655799/181936718-b5ed2597-fbf4-40a6-aec7-b8545f436720.png)

* Get DNS
  ![image](https://user-images.githubusercontent.com/30655799/181936768-0b30c275-af57-479c-85ab-785c4ff65fa9.png)
  
### FINAL RESULTS
![Screenshot from 2022-07-30 16-42-20-1](https://user-images.githubusercontent.com/30655799/181936845-01d6810d-10c9-49cc-8f66-1f24c5504481.png)
![Screenshot from 2022-07-30 16-42-26](https://user-images.githubusercontent.com/30655799/181936847-77c0ac43-875d-4f57-b739-3e1aae998ccf.png)









