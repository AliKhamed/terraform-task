resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_public1
  availability_zone = "${var.provider_region}a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_public2
  availability_zone = "${var.provider_region}b"
  map_public_ip_on_launch = "true"
  
  tags = {
    Name = "public-2"
  }
}

resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_private1
  availability_zone = "${var.provider_region}a"

  tags = {
    Name = "private-1"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_private2
  availability_zone = "${var.provider_region}b"

  tags = {
    Name = "private-2"
  }
}
