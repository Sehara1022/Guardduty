module "guardduty" {
  source                       = "./modules/guardduty"
  enable_guardduty             = var.enable_guardduty
  enable_s3_protection         = var.enable_s3_protection
  enable_malware_protection    = var.enable_malware_protection
  finding_publishing_frequency = var.finding_publishing_frequency
}

module "security_hub_with_guardduty" {
  source                       = "./modules/securityhub"
  region                       = var.aws_region
  enable_cis                   = var.enable_cis
  enable_foundational_security = var.enable_foundational_security
  enable_pci_dss               = var.enable_pci_dss
}
module "lambda_function" {
  source             = "./modules/lambda-eventbridge"
  lambda_name        = var.lambda_name
  lambda_runtime     = var.lambda_runtime
  source_email       = var.source_email
  destination_emails = var.destination_emails
  tags               = var.tags
}
