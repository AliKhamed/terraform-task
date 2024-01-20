resource "aws_route_table_association" "public-association-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public-r-1.id
}

resource "aws_route_table_association" "public-association-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public-r-1.id
}

resource "aws_route_table_association" "private-association-1" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.private-r.id
}

resource "aws_route_table_association" "private-association-2" {
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.private-r.id
}