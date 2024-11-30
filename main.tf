variable "canary_configs" {
  description = "Map of canary configurations with canary names and ZIP file paths."
  type        = map(string)
  default = {
    "billing" = "test-fixtures/billing.zip"
    "test"    = "test-fixtures/lambdatest.zip"
    # "order"   = "path/order.zip" # Add more canary configurations as needed
  }
}
resource "aws_iam_role" "canary" {
  name = "some-canary-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "canary_policy" {
  name = "some-canary-policy"
  role = aws_iam_role.canary.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetBucketLocation",
        "s3:ListAllMyBuckets",
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::some-bucket/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:CreateLogGroup"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
resource "aws_synthetics_canary" "some" {
  for_each             = var.canary_configs
  name                 = "${each.key}-canary"
  artifact_s3_location = "s3://canary-eucent1-bucket/logs"
  execution_role_arn   = aws_iam_role.canary.arn
  handler              = "apiCanaryBlueprint.handler"
  zip_file             = each.value
  runtime_version      = "syn-nodejs-puppeteer-9.0"

  schedule {
    expression = "rate(5 minutes)"
  }

  run_config {
    timeout_in_seconds = 60
  }

  success_retention_period = 31
  failure_retention_period = 31
}
resource "aws_cloudwatch_metric_alarm" "canary_alarm" {
  for_each            = var.canary_configs
  alarm_name          = "${each.key}-canary-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Failed"
  namespace           = "CloudWatchSynthetics"
  period              = 300
  statistic           = "Sum"
  threshold           = 1

  alarm_actions = [aws_sns_topic.some.arn]

  dimensions = {
    CanaryName = aws_synthetics_canary.some[each.key].name
  }
}

resource "aws_sns_topic" "some" {
  name = "some-canary-topic"
}

resource "aws_sns_topic_subscription" "some" {
  topic_arn = aws_sns_topic.some.arn
  protocol  = "email"
  endpoint  = "tavleen.kaur@publicissapient.com"
}
