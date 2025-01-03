resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.voting-app-vpc.id
  tags = {
    Name = "internet-gw-voting-app"
  }
}