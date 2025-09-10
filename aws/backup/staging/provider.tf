provider "aws" {
  region = var.region

  dynamic "assume_role" {
    for_each = var.provider_assume_role == true ? [1] : []
    content {
      role_arn = var.assume_role_arn
    }

  }
}

provider "aws" {
  alias  = "useast1"
  region = "us-east-1"
}