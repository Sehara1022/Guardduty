# Ensure Security Hub is enabled
resource "aws_securityhub_account" "main" {
}

# Subscribe to AWS Foundational Security Best Practices v1.0.0
resource "aws_securityhub_standards_subscription" "foundational_security" {
  count         = var.enable_foundational_security && !var.already_subscribed ? 1 : 0
  standards_arn = "arn:aws:securityhub:${var.region}::standards/aws-foundational-security-best-practices/v/1.0.0"
  depends_on    = [aws_securityhub_account.main]
}

# Subscribe to CIS AWS Foundations Benchmark v1.2.0
resource "aws_securityhub_standards_subscription" "cis" {
  count         = var.enable_cis && !var.already_subscribed ? 1 : 0
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
  depends_on    = [aws_securityhub_account.main]
}

# Subscribe to PCI-DSS v3.2.1
resource "aws_securityhub_standards_subscription" "pci_dss" {
  count         = var.enable_pci_dss && !var.already_subscribed ? 1 : 0
  standards_arn = "arn:aws:securityhub:${var.region}::standards/pci-dss/v/3.2.1"
  depends_on    = [aws_securityhub_account.main]

}


