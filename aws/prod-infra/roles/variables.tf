# General Variables
############################################################

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-2"
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "roles"
}


variable "provider_assume_role" {
  description = "Whether the provider should assume GHA Role Creator Deployment role"
  default     = false
  type        = bool
}

variable "assume_role_arn" {
  description = "The ARN of the role to assume"
  type        = string
  default     = "arn:aws:iam::696793786584:role/GHA_Role_Creator_Role"
}