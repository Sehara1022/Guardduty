resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
  tags = var.tags
}

resource "aws_iam_policy_attachment" "ses_access" {
  name       = "${var.lambda_name}-ses-access"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
  roles      = [aws_iam_role.lambda_role.name]
}

resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  name       = "${var.lambda_name}-basic-execution"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  roles      = [aws_iam_role.lambda_role.name]
}

resource "aws_lambda_function" "this" {
  function_name    = var.lambda_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = var.lambda_runtime
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  filename         = data.archive_file.lambda_zip.output_path

  # Set environment variables
  environment {
    variables = {
      SOURCE_EMAIL       = var.source_email
      DESTINATION_EMAILS = var.destination_emails
    }
  }
  tags = var.tags
}


data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 14
  tags              = var.tags
}

################################################################################
## EventBridge
################################################################################

resource "aws_cloudwatch_event_rule" "security_hub_rule" {
  name        = "${var.lambda_name}-event-rule"
  description = "Trigger Lambda on Security Hub findings"
  event_pattern = jsonencode({
    source = ["aws.securityhub"]
    detail = {
      findings = {
        ProductName = ["GuardDuty"]
        Severity = {
          Label = ["MEDIUM", "HIGH", "CRITICAL"]
        }
      }
    }
  })
  tags = var.tags
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.security_hub_rule.name
  target_id = "${var.lambda_name}-target"
  arn       = aws_lambda_function.this.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "${var.lambda_name}-eventbridge-permission"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.security_hub_rule.arn
}