output "scaling_policy_arn" {
  description = "Auto scaling policy ARN"
  value       = aws_appautoscaling_policy.cpu.arn
}
