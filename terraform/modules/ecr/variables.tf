variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "image_retention_count" {
  description = "Number of images to retain in repository"
  type        = number
  default     = 5
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
