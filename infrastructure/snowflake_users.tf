resource "snowflake_user" "demo_user" {
   provider = snowflake.security_admin
   name     = "company_demo_user"
   default_warehouse = snowflake_warehouse.warehouse.name
   default_role      = snowflake_role.svc_role.name
   default_namespace = "${snowflake_database.db.name}.${snowflake_schema.schema.name}"
   # Because the Terraform TLS private key generator doesn't export the public key in a 
   # format that the Terraform provider can consume, some string manipulation is needed.
   rsa_public_key    = substr(tls_private_key.svc_key.public_key_pem, 27, 398)
}

resource "tls_private_key" "svc_key" {
   algorithm = "RSA"
   rsa_bits  = 2048
}
