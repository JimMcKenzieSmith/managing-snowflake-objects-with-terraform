resource "snowflake_database" "db" {
  name = var.db_name
}

resource "snowflake_schema" "schema" {
   database = snowflake_database.db.name
   name     = var.schema_name
   is_managed = false
}

resource "snowflake_warehouse" "warehouse" {
  name           = var.warehouse_name
  warehouse_size = "xsmall"
  auto_suspend = 60
}
