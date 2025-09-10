locals {

  tags = {
    Owner       = "Terraform"
    Environment = "${var.env}"
    Project     = "kainoStudio"
    ServiceName = "kainoscore"
    Provider    = "aws"
  }
}
