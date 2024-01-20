output "vpc_id" {
    value = aws_vpc.main.id
}

output "vpc_cidr" {
    value = aws_vpc.main.cidr_block
}

output "subnet_id_p1" {
    value = aws_subnet.public-1.id
}

output "subnet_id_p2" {
    value = aws_subnet.public-2.id
}

output "subnet_id_pr1" {
    value = aws_subnet.private-1.id
}

output "subnet_id_pr2" {
    value = aws_subnet.private-2.id
}

