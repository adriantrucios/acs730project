output "aws_lb" {
  
  value = aws_lb.load_balancer.dns_name
}
