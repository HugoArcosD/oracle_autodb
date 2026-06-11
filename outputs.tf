output "db_name" {
  description = "Nome da base de dados Autonomous Database"
  value       = oci_database_autonomous_database.poc.display_name
}

output "db_state" {
  description = "Estado atual da base de dados"
  value       = oci_database_autonomous_database.poc.state
}

output "db_ocid" {
  description = "OCID da base de dados (ID único em OCI)"
  value       = oci_database_autonomous_database.poc.id
}

output "compartment_id" {
  description = "OCID do compartment criado"
  value       = oci_identity_compartment.poc.id
}

output "connection_strings" {
  description = "Connection strings para conectarse a la BD desde aplicaciones"
  value = {
    high      = oci_database_autonomous_database.poc.connection_strings[0].high
    medium    = oci_database_autonomous_database.poc.connection_strings[0].medium
    low       = oci_database_autonomous_database.poc.connection_strings[0].low
    tp        = oci_database_autonomous_database.poc.connection_strings[0].tp
    tpurgent  = oci_database_autonomous_database.poc.connection_strings[0].tpurgent
  }
}

output "sql_dev_web_url" {
  description = "URL para acceder a SQL Developer Web"
  value       = oci_database_autonomous_database.poc.connection_urls[0].sql_dev_web_url
}

output "apex_url" {
  description = "URL para acceder a APEX (Oracle Application Express)"
  value       = oci_database_autonomous_database.poc.connection_urls[0].apex_url
}
