resource "aws_lb" "web_load_balancer" {

    load_balancer_type="application"
    name="web-app-load-balancer"
    internal="false"
    subnets=[

        aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id

    ]  

    security_groups=[aws_security_group.external_lb_sg.id]


    tags={
        Name="web_app_load_balancer"
}

}

resource "aws_lb_target_group" "web_app_tg" {

    name="web-app-tg"
    vpc_id = aws_vpc.primary_vpc.id
    protocol = "HTTP"
    port = 80

    health_check{
        path="/"
        interval = 15
        healthy_threshold = 2
        unhealthy_threshold = 2
        matcher = "200"
    }

    tags={
        Name="web_app_tg"
    }
  
}



resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.web_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app_tg.arn
  }
}