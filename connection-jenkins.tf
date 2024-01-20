
resource "local_file" "inventory" {
  filename = "/var/jenkins_home/hosts"
  content  = <<EOF
[slave]
${aws_instance.application-server.private_ip}
EOF
}


resource "local_file" "private_key" {
  filename        = "/var/jenkins_home/pk"
  file_permission = 0400
  content         = <<EOF
${tls_private_key.myprivatekey.private_key_openssh}
EOF
}

resource "local_file" "sshconfig" {
  filename   = "/root/.ssh/config"
  depends_on = [local_file.private_key]
  content    = <<EOF
Host bastion
    User ubuntu
    HostName ${aws_instance.bastion-server.public_ip}
    IdentityFile "/var/jenkins_home/pk"
Host ${aws_instance.application-server.private_ip}
    Port 22
    User ubuntu
    ProxyCommand ssh -o StrictHostKeyChecking=no -A -W %h:%p -q bastion
    StrictHostKeyChecking no
    IdentityFile "/var/jenkins_home/pk"
EOF
}
