module "bootstrap" {
  source = "./modules/bootstrap"

  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}
