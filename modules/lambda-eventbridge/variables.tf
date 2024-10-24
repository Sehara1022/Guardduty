variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
}

# Source email for SES (dynamically used in Lambda)
variable "source_email" {
  description = "Source email for SES notifications"
  type        = string
}

# Destination emails for SES (dynamically used in Lambda, comma-separated)
variable "destination_emails" {
  description = "Comma-separated list of destination emails for SES notifications"
  type        = string
}

variable "lambda_runtime" {
  description = "runtime of the Lambda function"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}