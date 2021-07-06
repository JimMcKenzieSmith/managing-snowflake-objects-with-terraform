resource "snowflake_table" "student_table" {
  database   = snowflake_database.db.name
  schema     = snowflake_schema.schema.name
  name       = var.student_table_name
  comment    = "A demo student table."
  # cluster_by = ["to_date(create_ts)"]
  
  column {
    name = "ID"
    type = "int"
  }

  column {
    name = "FIRST_NAME"
    type = "text"
  }

  column {
    name = "LAST_NAME"
    type = "text"
  }

  column {
    name = "GRADE"
    type = "int"
  }

  column {
    name = "CREATE_TS"
    type = "TIMESTAMP_NTZ(9)"
  }
}