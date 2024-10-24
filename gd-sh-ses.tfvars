aws_region                   = "eu-west-2"
enable_guardduty             = true
enable_s3_protection         = true
enable_malware_protection    = false
finding_publishing_frequency = "FIFTEEN_MINUTES"

enable_cis                   = true
enable_foundational_security = true
enable_pci_dss               = false
already_subscribed           = false
tags = {
  Environment = "dev"
  Project     = "GuardDutySecurityHub"
  Owner       = "Aleti"
}

lambda_name        = "GuardDuty-SecurityHub"
lambda_runtime     = "python3.12"
source_email       = "seharabanumulla@gmail.com"
destination_emails = "babithatenepalli@gmail.com"