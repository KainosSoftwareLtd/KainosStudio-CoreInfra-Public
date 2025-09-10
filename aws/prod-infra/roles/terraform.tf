terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    encrypt        = true
    region         = "eu-west-2"
    dynamodb_table = "terraform-kainoscore-lock"
    kms_key_id     = "e7d66df5-64eb-46a0-b89a-65f34127d81d"
  }
}