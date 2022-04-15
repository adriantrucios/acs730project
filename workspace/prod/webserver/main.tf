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
    bucket = "group-10-acs-project-prod"
    key    = "prod/network/terraform.tfstate"
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

# webserver EC2 instance
resource "aws_instance" "webserver" {
  count                       = var.ec2_count
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.private_subnet_ids[count.index]
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(local.prefix)
    }
  )

  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-webserver-${count.index + 1}"
    }
  )
}


# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = local.name_prefix
  public_key = file("gopal.pub")
}


# Security Group of webserver
resource "aws_security_group" "web_sg" {
  name        = "allow_http_ssh_web"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
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



resource "aws_lb" "load_balancer" {
  name               = "load-balancer-prod"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = data.terraform_remote_state.network.outputs.public_subnet_ids[*]
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-App_load"
    }
  )
}


resource "aws_lb_listener" "lb_listen" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group" "target_group" {
  health_check {
    interval            = 15
    path                = "/"
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }
  name        = "tg-alb-dev"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
}

resource "aws_security_group" "lb_sg" {
  name        = "allow_http_lb"
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

resource "aws_lb_target_group_attachment" "ec2_attach" {
  count            = length(aws_instance.webserver)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.webserver[count.index].id
  port             = 80
}
