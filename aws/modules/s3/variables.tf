variable "bucket_name" {
  description = "Name of the S3 bucket."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the S3 bucket."
  type        = map(string)
  default     = {}
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket. If Object Lock or MFA Delete is enabled, versioning must be enabled"
  type        = bool
  default     = false
}

variable "enable_logging" {
  description = "Enable server access logging for the S3 bucket."
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "The target bucket to store logs."
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "The prefix for log object keys."
  type        = string
  default     = null
}

variable "enable_encryption" {
  description = "Enable server-side encryption for the S3 bucket."
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "KMS key ID for server-side encryption."
  type        = string
  default     = null
}

variable "enable_public_access_block" {
  description = "Enable public access block for the S3 bucket."
  type        = bool
  default     = false
}

variable "upload_files" {
  description = "Enable uploading static files to the S3 bucket."
  type        = bool
  default     = false
}

variable "files_path" {
  description = "Local path to the static files to upload."
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment name, used for logging prefix."
  type        = string
  default     = "dev"
}

variable "enable_object_lock" {
  description = "Enable Object lock on the bucket"
  type        = bool
  default     = false
}

variable "object_lock_mode" {
  description = "Object lock mode (GOVERNANCE or COMPILANCE)"
  type        = string
  default     = "GOVERNANCE"
  validation {
    condition     = contains(["GOVERNANCE", "COMPILANCE"], var.object_lock_mode)
    error_message = "The object_lock_mode value must be 'GOVERNANCE' or 'COMPILANCE'."
  }
}

variable "object_lock_retention_days" {
  description = "Number of retention days in Object Lock"
  type        = number
  default     = 30
}

variable "enable_mfa_delete" {
  description = "Enable MFA Delete for the bucket"
  type        = bool
  default     = false
}

variable "enable_lifecycle_expiration" {
  description = "Enable automatic object expiration after a number of days"
  type        = bool
  default     = false
}

variable "expiration_days" {
  description = "Number of days after which object should expire"
  type        = number
  default     = 0
}

variable "s3_object_ownership" {
  description = "Object ownership setting for the bucket. Valid values: BucketOwnerPreferred, BucketOwnerEnforced, ObjectWriter"
  type        = string
  default     = "BucketOwnerPreferred"
}

variable "additional_bucket_policy_documents" {
  description = "Optional list of JSON policy documents to merge with the module's bucket policy"
  type        = list(string)
  default     = []
}

variable "enable_cors" {
  description = "Enable cors defininition"
  type        = bool
  default     = false
}

variable "cors_allowed_headers" {
  description = "Allowed headers in cors defininition"
  type        = list(string)
  default     = []
}

variable "cors_allowed_methods" {
  description = "Allowed methods in cors defininition"
  type        = list(string)
  default     = []
}

variable "cors_allowed_origins" {
  description = "Allowed origins in cors defininition"
  type        = list(string)
  default     = []
}