resource "aws_internet_gateway" "public_subnet_ig" {

      vpc_id=aws_vpc.primary_vpc.id
      tags={
        Name="public_subnet_ig"
      }
}

resource "aws_route_table" "public_subnet_rt" {
    vpc_id = aws_vpc.primary_vpc.id
    tags={
        Name="public_subnet_rt"
    }
}

resource "aws_route" "public_subnet_rt" {

  route_table_id = aws_route_table.public_subnet_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.public_subnet_ig.id
}

resource "aws_route_table_association" "pub_sub_rt" {
    count=2
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_subnet_rt.id
  
}