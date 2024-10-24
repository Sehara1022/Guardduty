variable "enable_guardduty" {
  description = "Flag to enable or disable GuardDuty"
  type        = bool
  default     = true
}

variable "enable_s3_protection" {
  description = "Enable GuardDuty for monitoring S3 access logs"
  type        = bool
  default     = true
}

variable "enable_malware_protection" {
  description = "Enable GuardDuty Malware Protection for EBS volumes"
  type        = bool
  default     = false
}

variable "finding_publishing_frequency" {
  description = "Frequency for GuardDuty findings publishing (FIFTEEN_MINUTES, ONE_HOUR, SIX_HOURS)"
  type        = string
  default     = "FIFTEEN_MINUTES"
}