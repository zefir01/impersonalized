data "aws_iam_policy_document" "cloudwatch" {
  statement {
    actions = [
      "cloudwatch:PutMetricData",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

locals {
  monitoringName = "${var.stack}-monitoring"
  slackName      = "${var.stack}-slack"
}

module "monitoring" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "3.2.0"

  function_name = local.monitoringName
  description   = "Check frontend is live"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  publish       = true

  environment_variables = {
    URL = var.url
  }

  source_path = [
    "${path.module}/monitoring/index.py",
    {
      pip_requirements = "${path.module}/monitoring/requirements.txt"
      prefix_in_zip    = "vendor"
    }
  ]

  tags = {
    Name = local.monitoringName
  }

  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.cloudwatch.json

  allowed_triggers = {
    OneRule = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.monitoring.arn
    }
  }
}

resource "aws_cloudwatch_event_rule" "monitoring" {
  name                = "Monitoring"
  description         = "Run monitoring lambdas"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "monitoring" {
  rule = aws_cloudwatch_event_rule.monitoring.name
  arn  = module.monitoring.lambda_function_arn
}

resource "aws_cloudwatch_metric_alarm" "front" {
  alarm_name                = var.alarm_name
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "isOK"
  namespace                 = "Monitoring"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "Frontend down"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.alarms.arn]
  ok_actions                = [aws_sns_topic.alarms.arn]

  dimensions = {
    url = var.url
  }
}

resource "aws_sns_topic" "alarms" {
  name = "alarms"
}

module "notify_slack" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 5.1"

  sns_topic_name = aws_sns_topic.alarms.name

  slack_webhook_url = "https://hooks.slack.com/services/ascascascasc/ascascascasc/ascascascascasc"
  slack_channel     = "dev-monitoring"
  slack_username    = "monitoring"
}