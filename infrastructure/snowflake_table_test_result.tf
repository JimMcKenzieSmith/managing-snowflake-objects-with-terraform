resource "snowflake_table" "test_result_table" {
  database   = snowflake_database.db.name
  schema     = snowflake_schema.schema.name
  name       = "TEST_RESULT"
  comment    = "A demo test result table."
  # cluster_by = ["to_date(create_ts)"]
  
  column {
    name = "ID"
    type = "int"
  }

  column {
    name = "TEST_VERSION"
    type = "int"
  }

  column {
    name = "TEST_DATA"
    type = "text"
  }

  column {
    name = "CREATE_TS"
    type = "TIMESTAMP_NTZ(9)"
  }
}