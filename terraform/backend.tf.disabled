terraform {
  backend "s3" {
    bucket         = "goldenowl-dev-tfstate"
    key            = "ecs/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "goldenowl-dev-tflock"
    encrypt        = true
  }
}
