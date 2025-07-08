resource "aws_vpc" "primary_vpc" {
 
           cidr_block="192.168.0.0/16"
           tags={
            Name=" primary_vpc"
           }
           
}


locals {
  subnet_names=["a","b"]
}


resource "aws_subnet" "public_subnet" {

    count= 2
    vpc_id=aws_vpc.primary_vpc.id
    cidr_block=cidrsubnet(aws_vpc.primary_vpc.cidr_block,8,count.index)
    availability_zone=data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
    tags={
            Name = "public_subnet.${local.subnet_names[count.index]}"

    }
}

resource "aws_subnet" "app_subnet_private" {
    count=2
    vpc_id=aws_vpc.primary_vpc.id
    cidr_block=cidrsubnet(aws_vpc.primary_vpc.cidr_block,8,count.index+2)
    availability_zone = data.aws_availability_zones.available.names[count.index]
     tags={
            Name = "app_private_subnet.${local.subnet_names[count.index]}"

    }

}

resource "aws_subnet" "db_private_subnet" {
    count=2
    vpc_id=aws_vpc.primary_vpc.id
    cidr_block=cidrsubnet(aws_vpc.primary_vpc.cidr_block,8,count.index+4)
    availability_zone=data.aws_availability_zones.available.names[count.index]
     tags={
            Name = "db_private_subnet.${local.subnet_names[count.index]}"

    }
  
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [for subnet in aws_subnet.db_private_subnet : subnet.id]

  tags = {
    Name = "RDS Subnet Group"
  }
}