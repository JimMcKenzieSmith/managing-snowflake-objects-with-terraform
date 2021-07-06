terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.22.0"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = var.region

  # NOTE: this auth is only for sandbox testing... change this to use standards:
  access_key = var.aws_key_id
  secret_key = var.aws_secret_key
}

provider "snowflake" {
  role = "SYSADMIN"
}

provider "snowflake" {
   alias    = "security_admin"
   role     = "SECURITYADMIN"
}
