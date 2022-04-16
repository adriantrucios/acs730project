#  Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Use remote state to retrieve network data
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "acs730project-staging"
    key    = "staging/network/terraform.tfstate"
    region = "us-east-1"
  }
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix       = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}

# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../../../modules/globalvars"
}

# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = local.name_prefix
  public_key = file("gopal.pub")
}


# Security Group of webserver
resource "aws_security_group" "web_sg_staging" {
  name        = "allow_http_ssh_web_staging"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg_staging.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-web-sg"
    }
  )
}



resource "aws_lb" "load_balancer_staging" {
  name               = "load-balancer-staging"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg_staging.id]
  subnets            = data.terraform_remote_state.network.outputs.public_subnet_ids[*]
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-App_load"
    }
  )
}


resource "aws_lb_listener" "lb_listen_staging" {
  load_balancer_arn = aws_lb.load_balancer_staging.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_staging.arn
  }
}

resource "aws_lb_target_group" "target_group_staging" {
  health_check {
    interval            = 15
    path                = "/"
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }
  name        = "tg-alb-staging"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
}

resource "aws_security_group" "lb_sg_staging" {
  name        = "allow_http_lb_staging"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description = "HTTP from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-lbsg"
    }
  )
}

resource "aws_launch_configuration" "webserver_staging" {
  name_prefix                 = "staging-web-"
  image_id                    = "ami-0a3c14e1ddbe7f23c"
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.web_key.key_name
  security_groups             = [aws_security_group.web_sg_staging.id]
  associate_public_ip_address = true
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = "staging",
      prefix = "finalproject"
    }
  )
}

resource "aws_autoscaling_group" "web_staging" {
  name                 = "aws_autoscaling_group_asg_staging"
  min_size             = 1
  desired_capacity     = 3
  max_size             = 4
  health_check_type    = "ELB"
  target_group_arns = ["${aws_lb_target_group.target_group_staging.id}"]
  launch_configuration = aws_launch_configuration.webserver_staging.name
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  vpc_zone_identifier = [
    data.terraform_remote_state.network.outputs.private_subnet_ids[0],
    data.terraform_remote_state.network.outputs.private_subnet_ids[1],
    data.terraform_remote_state.network.outputs.private_subnet_ids[2],
    
    ]
  
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "webserver-staging"
    propagate_at_launch = true

  }
}


resource "aws_autoscaling_policy" "web_policy_up_staging" {
  name                   = "web_policy_up_staging"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_staging.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up_staging" {
  alarm_name          = "web_cpu_alarm_up_staging"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web_staging.name}"
  }
  alarm_description = "Metric to monitor EC2 CPU usage"
  alarm_actions     = ["${aws_autoscaling_policy.web_policy_up_staging.arn}"]
}


resource "aws_autoscaling_policy" "web_policy_down_staging" {
  name                   = "web_policy_down_staging"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_staging.name
}


resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down_staging" {
  alarm_name          = "web_cpu_alarm_down_staging"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web_staging.name}"
  }
  alarm_description = "Metric to monitor EC2 CPU usage"
  alarm_actions     = ["${aws_autoscaling_policy.web_policy_up_staging.arn}"]
}


