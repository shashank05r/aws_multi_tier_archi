resource "aws_launch_template" "web_launch_temp" {

    name_prefix="public_instnce_image"
    image_id= var.ami_id
    instance_type=var.instance_type
     vpc_security_group_ids = [aws_security_group.ext_asg_sg.id]
     user_data = filebase64("script.sh")

}

resource "aws_autoscaling_group" "ext_asg_sg" {
   max_size = 3
   min_size=2
desired_capacity = 2
   vpc_zone_identifier = aws_subnet.public_subnet[*].id

    

  launch_template {
    id=aws_launch_template.web_launch_temp.id
    version = "$Latest"  

  }





target_group_arns = [aws_lb_target_group.web_app_tg.arn]
  health_check_type = "EC2"

  tag {
    key                 = "Name"
    value               = "web-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

