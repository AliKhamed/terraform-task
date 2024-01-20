resource "aws_security_group" "allow-ssh" {
  name        = "allow-ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh"
  }
}


resource "aws_security_group" "allow-3000" {
  name        = "allow-3000"
  description = "Allow port 3000"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "Allow port 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [module.network.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.network.vpc_cidr]
  }

  tags = {
    Name = "allow-3000"
  }
}

resource "aws_security_group" "allow-3306" {
  name        = "allow-3306"
  description = "Allow port 3306"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "Allow port 3306"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.network.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.network.vpc_cidr]
  }

  tags = {
    Name = "allow-3306"
  }
}

resource "aws_security_group" "allow-6379" {
  name        = "allow-6379"
  description = "Allow port 6379"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "Allow port 6379"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [module.network.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.network.vpc_cidr]
  }

  tags = {
    Name = "allow-6379"
  }
}

resource "aws_security_group" "allow-80" {
  name        = "allow-80"
  description = "Allow 80 inbound traffic"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "Allow 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.alb-name}-alb_sg"
  }
}
