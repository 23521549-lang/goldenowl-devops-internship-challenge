terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Uncomment after running bootstrap module
  # backend "s3" {
  #   bucket         = "goldenowl-dev-tfstate"
  #   key            = "ecs/terraform.tfstate"
  #   region         = "ap-southeast-1"
  #   dynamodb_table = "goldenowl-dev-tflock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region
}
