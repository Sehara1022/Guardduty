output "lambda_function_arn" {
  value       = aws_lambda_function.this.arn
  description = "The ARN of the Lambda function"
}

output "lambda_role_arn" {
  value       = aws_iam_role.lambda_role.arn
  description = "The ARN of the IAM role for the Lambda function"
}

output "cloudwatch_log_group_name" {
  value       = aws_cloudwatch_log_group.this.name
  description = "The name of the CloudWatch Log Group for the Lambda function"
}

output "eventbridge_rule_arn" {
  value       = aws_cloudwatch_event_rule.security_hub_rule.arn
  description = "The ARN of the EventBridge rule that triggers the Lambda function"
}

output "eventbridge_target_id" {
  value       = aws_cloudwatch_event_target.lambda_target.target_id
  description = "The target ID for the EventBridge rule"
}
