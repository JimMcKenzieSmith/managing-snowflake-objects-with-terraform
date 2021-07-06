resource snowflake_pipe student_pipe {
  database = snowflake_database.db.name
  schema   = snowflake_schema.schema.name
  name     = "STUDENT_PIPE"

  comment = "A pipe to auto ingest from s3."

  # NOTE: You cannot "MERGE INTO" with a pipe. This must be a "COPY INTO" statement!
  copy_statement = "COPY INTO ${var.db_name}.${var.schema_name}.${var.student_table_name} FROM @${var.db_name}.${var.schema_name}.${var.student_stage_name} file_format = (type = '${var.s3_file_format}')"
  auto_ingest    = true

  # NOTE: there is issue with 'terraform destroy' here... if a pipe is already created with a specific arn, then Snowflake will not recreate the sns subscription on 
  # a 'terraform apply'. See this page for details: https://community.snowflake.com/s/article/Subscription-does-not-show-up-in-snowpipe-with-SNS-configuration-while-using-snowpipe
  # A workaround is to rename the sns topic (maybe with a version number?), or contact Snowflake support.
  aws_sns_topic_arn = aws_sns_topic.snowflake-notification.arn
  depends_on = [
    snowflake_table.student_table, 
    snowflake_stage.student_stage,
    aws_sns_topic_policy.snowflake-sns-topic-policy
  ]
}