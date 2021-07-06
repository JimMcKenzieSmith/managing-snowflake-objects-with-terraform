resource "aws_sns_topic" "snowflake-notification" {
  name = "${var.environment}-snowflake-notification3"
  tags = local.tags
}

resource "aws_sns_topic_policy" "snowflake-sns-topic-policy" {
  arn = aws_sns_topic.snowflake-notification.arn

  policy = data.aws_iam_policy_document.snowflake-sns-policy-document.json
}

data "aws_iam_policy_document" "snowflake-sns-policy-document" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
    
      values = [
        var.account_id[var.environment]
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.snowflake-notification.arn,
    ]

    sid = "__default_statement_ID"
  }

  statement {
    actions = [
      "SNS:Publish"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
    
      values = [
        var.account_id[var.environment]
      ]
    }

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.snowflake-notification.arn,
    ]

    sid = "__s3_pub_0"
  }

  statement {
    actions = [
      "SNS:Subscribe"
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.snowflake_sns_principal[var.environment]}"]
    }

    resources = [
      aws_sns_topic.snowflake-notification.arn,
    ]

    sid = "__snowflake_sub_0"
  }
}
