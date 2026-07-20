output "alb_dns_name" {
  description = "ALB DNS name (deployment URL)"
  value       = aws_lb.this.dns_name
}

output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.this.arn
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = aws_lb_target_group.this.arn
}

output "listener_arn" {
  description = "ALB listener ARN"
  value       = aws_lb_listener.http.arn
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}
