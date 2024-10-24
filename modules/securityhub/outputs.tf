output "securityhub_account_id" {
  value       = aws_securityhub_account.main.id
  description = "The AWS account ID in Security Hub"
}

output "foundational_security_subscription_arn" {
  value       = var.enable_foundational_security && !var.already_subscribed ? aws_securityhub_standards_subscription.foundational_security[0].standards_arn : null
  description = "ARN of the Foundational Security Best Practices subscription"
}

output "cis_subscription_arn" {
  value       = var.enable_cis && !var.already_subscribed ? aws_securityhub_standards_subscription.cis[0].standards_arn : null
  description = "ARN of the CIS AWS Foundations Benchmark subscription"
}

output "pci_dss_subscription_arn" {
  value       = var.enable_pci_dss && !var.already_subscribed ? aws_securityhub_standards_subscription.pci_dss[0].standards_arn : null
  description = "ARN of the PCI-DSS subscription"
}


