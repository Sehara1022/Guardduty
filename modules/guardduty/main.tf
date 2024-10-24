resource "aws_guardduty_detector" "guardduty" {
  enable = var.enable_guardduty

  datasources {
    s3_logs {
      enable = var.enable_s3_protection
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = var.enable_malware_protection
        }
      }
    }
  }

  finding_publishing_frequency = var.finding_publishing_frequency
}
