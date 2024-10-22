variable "region" {
  description = "AWS region"
  type        = string
  default     = ""
}

variable "enable_cis" {
  description = "Enable CIS AWS Foundations Benchmark v1.2.0"
  type        = bool
  default     = true
}

variable "enable_foundational_security" {
  description = "Enable AWS Foundational Security Best Practices v1.0.0"
  type        = bool
  default     = true
}

variable "enable_pci_dss" {
  description = "Enable PCI-DSS v3.2.1"
  type        = bool
  default     = false
}

variable "enable_guardduty" {
  description = "Enable Amazon GuardDuty findings subscription"
  type        = bool
  default     = true
}

variable "already_subscribed" {
  description = "Whether the account is already subscribed to the standard"
  type        = bool
  default     = false
}


variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}