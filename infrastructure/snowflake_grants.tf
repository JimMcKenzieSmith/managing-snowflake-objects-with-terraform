resource "snowflake_role_grants" "grants" {
   role_name = snowflake_role.svc_role.name
   users     = [snowflake_user.demo_user.name]
}

resource "snowflake_database_grant" "grant" {
   database_name = snowflake_database.db.name
   privilege = "USAGE"
   roles     = [snowflake_role.svc_role.name]
   with_grant_option = false
}
resource "snowflake_schema_grant" "grant" {
   database_name = snowflake_database.db.name
   schema_name   = snowflake_schema.schema.name
   privilege = "USAGE"
   roles     = [snowflake_role.svc_role.name]
   with_grant_option = false
}
resource "snowflake_warehouse_grant" "grant" {
   warehouse_name = snowflake_warehouse.warehouse.name
   privilege      = "USAGE"
   roles = [snowflake_role.svc_role.name]
   with_grant_option = false
}