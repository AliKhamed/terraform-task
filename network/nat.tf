resource "aws_nat_gateway" "nat-1" {
  allocation_id = aws_eip.elp1.id
  subnet_id     = aws_subnet.public-1.id

  tags = {
    Name = "NAT-1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
