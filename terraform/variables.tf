variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "container_port" {
  description = "Application container port"
  type        = number
  default     = 3000
}

variable "container_image" {
  description = "Docker image URI"
  type        = string
  default     = "nginx:latest"
}

variable "task_cpu" {
  description = "ECS task CPU units"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "ECS task memory (MiB)"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired task count"
  type        = number
  default     = 1
}

variable "autoscaling_min" {
  description = "Minimum number of tasks"
  type        = number
  default     = 1
}

variable "autoscaling_max" {
  description = "Maximum number of tasks"
  type        = number
  default     = 3
}
