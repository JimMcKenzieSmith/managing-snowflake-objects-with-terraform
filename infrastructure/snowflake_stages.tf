resource "snowflake_stage" "student_stage" {
  name        = var.student_stage_name
  url         = "s3://${var.s3_student_bucket[var.environment]}/"
  database    = snowflake_database.db.name
  schema      = snowflake_schema.schema.name
  credentials = "AWS_KEY_ID='${var.aws_key_id}' AWS_SECRET_KEY='${var.aws_secret_key}'"
}