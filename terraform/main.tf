locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "networking" {
  source = "./modules/networking"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  tags                 = local.common_tags
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}

module "iam" {
  source = "./modules/iam"

  project_name       = var.project_name
  environment        = var.environment
  ecr_repository_arn = module.ecr.repository_arn
  tags               = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = module.networking.vpc_id
  subnet_ids     = module.networking.public_subnet_ids
  container_port = var.container_port
  tags           = local.common_tags
}

module "ecs" {
  source = "./modules/ecs"

  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.networking.vpc_id
  subnet_ids                = module.networking.private_subnet_ids
  container_image           = var.container_image
  container_port            = var.container_port
  cpu                       = var.task_cpu
  memory                    = var.task_memory
  desired_count             = var.desired_count
  health_check_grace_period = var.health_check_grace_period
  ecs_execution_role_arn    = module.iam.ecs_execution_role_arn
  ecs_task_role_arn         = module.iam.ecs_task_role_arn
  target_group_arn          = module.alb.target_group_arn
  alb_listener_arn          = module.alb.listener_arn
  alb_security_group_id     = module.alb.alb_security_group_id
  tags                      = local.common_tags
}

module "autoscaling" {
  source = "./modules/autoscaling"

  project_name     = var.project_name
  environment      = var.environment
  ecs_cluster_name = module.ecs.cluster_name
  ecs_service_name = module.ecs.service_name
  min_capacity     = var.autoscaling_min
  max_capacity     = var.autoscaling_max
  tags             = local.common_tags
}
