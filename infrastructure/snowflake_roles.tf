resource "snowflake_role" "svc_role" {
   provider = snowflake.security_admin
   name     = var.snowflake_svc_role
}
