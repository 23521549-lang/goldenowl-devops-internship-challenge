output "app_url" {
  description = "Application URL (ALB DNS)"
  value       = "http://${module.alb.alb_dns_name}"
}

output "ecr_repository_url" {
  description = "ECR repository URL for CI/CD"
  value       = module.ecr.repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name for CI/CD"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "ECS service name for CI/CD"
  value       = module.ecs.service_name
}
