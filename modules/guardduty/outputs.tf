output "guardduty_enabler" {
  description = "guardduty enabler resource ID"
  value       = aws_guardduty_detector.guardduty.id
}
