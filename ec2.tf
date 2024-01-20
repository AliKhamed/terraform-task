# ec2 bastion 

resource "aws_instance" "bastion-server" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_type
  associate_public_ip_address = true
  subnet_id                   = module.network.subnet_id_p1
  vpc_security_group_ids      = [aws_security_group.allow-ssh.id]
  key_name                    = aws_key_pair.generated_key.key_name

  tags = {
    Name = "bastion-server"
  }

  # set provisioner 
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public_ips.txt"
  }
}

//  Ec2
resource "aws_instance" "application-server" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  subnet_id              = module.network.subnet_id_pr1
  vpc_security_group_ids = [aws_security_group.allow-ssh.id, aws_security_group.allow-3000.id]
  key_name               = aws_key_pair.generated_key.key_name

  tags = {
    Name = "application"
  }
}
