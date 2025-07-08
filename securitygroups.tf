
// Security group of EXTERNAL LOAD BALANCER


resource "aws_security_group" "external_lb_sg" {

    vpc_id = aws_vpc.primary_vpc.id

    ingress{
        from_port = 80
        to_port=80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{

        from_port = 0
        to_port=0
        protocol = "-1"
        cidr_blocks=["0.0.0.0/0"]
    }
    tags={
        Name="external_lb_sg"
    }
  
}
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------








// Security group for External Auto-Scaling Group
resource "aws_security_group" "ext_asg_sg" {

    vpc_id = aws_vpc.primary_vpc.id 

     ingress{
        from_port = 80
        to_port=80
        protocol = "tcp"
        security_groups=[aws_security_group.external_lb_sg.id]
    }

    egress{
                   from_port = 0
                   to_port = 0
                   protocol = "-1"
                   cidr_blocks = ["0.0.0.0/0"]
    }
  tags={
    Name="ext_asg"
  }
}
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





//  Security group of launch template

/*resource "aws_security_group" "web_ec2_sg" {

    vpc_id=aws_vpc.primary_vpc.id

    egress{
        from_port=0
        to_port=0
        protocol=-1
        cidr_blocks=["0.0.0.0/0"]

    }
}

resource "aws_security_group_rule" "web_sg_rule" {
      type="ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = aws_security_group.web_ec2_sg.id
    source_security_group_id = aws_security_group.ex_asg_sg_rule.id
}*/

resource "aws_security_group" "ext_lt" {

    vpc_id = aws_vpc.primary_vpc.id

    ingress{
        from_port = 80
        to_port=80
        protocol = "tcp"
        security_groups=[aws_security_group.ext_asg_sg.id]
    }

    egress{

        from_port = 0
        to_port=0
        protocol = "-1"
        cidr_blocks=["0.0.0.0/0"]
    }
    tags={
        Name="ext_lt"
    }
  
}
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


resource "aws_security_group" "db_sg" {

    name="db_sample"

    description = "Allow DB traffic"

    vpc_id = aws_vpc.primary_vpc.id

    ingress{
        from_port="3306"
        to_port="3306"
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    }

    egress{
                from_port="0"
                to_port="0"
                protocol="-1"
                cidr_blocks=["0.0.0.0/0"]
    }
  tags={
    Name="db_sg"
  }
}
