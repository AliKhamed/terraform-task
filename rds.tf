
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [module.network.subnet_id_pr1, module.network.subnet_id_pr2]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "mydb"
  username             = aws_ssm_parameter.rds_username.value
  password             = aws_ssm_parameter.rds_password.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  # set db subnet group name
  db_subnet_group_name = aws_db_subnet_group.default.name
  # set security group from securitygroup.tf
  vpc_security_group_ids = [aws_security_group.allow-ssh.id, aws_security_group.allow-3000.id, aws_security_group.allow-3306.id]
  # set database port
  port = 3306
  depends_on = [
    aws_ssm_parameter.rds_username,
    aws_ssm_parameter.rds_password
  ]
}

# use system manager service to store environment variable 
# get the rds hostname 
resource "aws_ssm_parameter" "rds_endpoint" {
  name        = "/dev/database/endpoint"
  description = "rds endpoint"
  type        = "SecureString"
  # get rds hostname
  value = aws_db_instance.default.address

  tags = {
    environment = "dev"
  }
}

# get the rds hostname 
resource "aws_ssm_parameter" "rds_username" {
  name        = "/dev/database/username"
  description = "rds username"
  type        = "SecureString"
  value       = var.rds_username

  tags = {
    environment = "dev"
  }
}

# get the rds hostname 
resource "aws_ssm_parameter" "rds_password" {
  name        = "/dev/database/password"
  description = "rds password"
  type        = "SecureString"
  value       = var.rds_password

  tags = {
    environment = "dev"
  }
}