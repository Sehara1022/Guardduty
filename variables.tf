variable "aws_region" {
  description = "The AWS region to deploy the Inspector"
  type        = string
}
#####################################################################
##GuardDuty Variables
#####################################################################
variable "enable_guardduty" {
  description = "Flag to enable or disable GuardDuty"
  type        = bool
}

variable "enable_s3_protection" {
  description = "Enable GuardDuty for monitoring S3 access logs"
  type        = bool
}

variable "enable_malware_protection" {
  description = "Enable GuardDuty Malware Protection for EBS volumes"
  type        = bool
}

variable "finding_publishing_frequency" {
  description = "Frequency for GuardDuty findings publishing (FIFTEEN_MINUTES, ONE_HOUR, SIX_HOURS)"
  type        = string
}
#####################################################################
##SecurityHub Variables
#####################################################################
variable "enable_cis" {
  description = "Enable CIS AWS Foundations Benchmark v1.2.0"
  type        = bool
}

variable "enable_foundational_security" {
  description = "Enable AWS Foundational Security Best Practices v1.0.0"
  type        = bool
}

variable "enable_pci_dss" {
  description = "Enable PCI-DSS v3.2.1"
  type        = bool
}

variable "already_subscribed" {
  description = "Whether the account is already subscribed to the standard"
  type        = bool
}


variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}
#####################################################################
## Lambda Function Variables
#####################################################################
variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_runtime" {
  description = "runtime of the Lambda function"
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