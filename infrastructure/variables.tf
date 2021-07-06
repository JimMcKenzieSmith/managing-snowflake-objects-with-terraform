variable "environment" {
  default = "dev"
}

variable "technical_owner" {
  default = "Jim"
}

variable "s3_student_bucket" {
  type = map(string)
  default = {
    prd = ""
    int = ""
    dev = "S3_BUCKET_NAME_HERE"
  }

  description = "The s3 bucket that snowflake will auto ingest from, for student data."
}

variable "account_id" {
  type = map(string)
  default = {
    prd = ""
    int = ""
    dev = "AWS_ACCOUNT_HERE"
  }
}

variable "snowflake_sns_principal" {
  type = map(string)
  default = {
    prd = ""
    int = ""
    dev = "SNOWFLAKE_SNS_PRINCIPAL_HERE"
  }
}

variable "aws_key_id" {
  type = string
  description = "The aws key id of the account hosting the sns and s3 bucket."
}

variable "aws_secret_key" {
  type = string
  description = "The aws secret key of the account hosting the sns and s3 bucket."
}

variable "student_table_name" {
  type = string
  description = "The table name for storing student data."
}

variable "student_stage_name" {
  type = string
  description = "The stage name for storing student data."
}

variable "student_pipe_name" {
  type = string
  description = "The pipe name for pulling in student data."
}

variable "db_name" {
  description = "Name of the database."
  type        = string
}

variable "schema_name" {
  description = "Name of the schema."
  type        = string
}

variable "warehouse_name" {
  description = "Warehouse to grant."
  type        = string
}

variable "s3_file_format" {
  description = "Type of file format for copy statement"
  type        = string
}

variable "snowflake_svc_role" {
  description = "Service role for Snowflake."
  type = string
}

variable "region" {
  description = "AWS region"
  type = string
}
