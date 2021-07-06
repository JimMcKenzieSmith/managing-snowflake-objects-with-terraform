resource "aws_s3_bucket" "snowflake-student-bucket" {
  bucket = var.s3_student_bucket[var.environment]
  acl    = "private"

  # this will destroy the bucket on 'terraform destroy', even if it is not empty:
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = local.tags
}

resource "aws_s3_bucket_public_access_block" "block-snowflake-student-bucket" {
  bucket = aws_s3_bucket.snowflake-student-bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
  depends_on = [
    aws_sns_topic_policy.snowflake-sns-topic-policy,
    aws_s3_bucket_notification.bucket-notification
  ]
}

resource "aws_s3_bucket_notification" "bucket-notification" {
  bucket = aws_s3_bucket.snowflake-student-bucket.id

  topic {
    topic_arn     = aws_sns_topic.snowflake-notification.arn
    events        = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_sns_topic_policy.snowflake-sns-topic-policy
  ]
}
