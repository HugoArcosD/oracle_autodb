output "db_name" {
  description = "Name of the Autonomous Database"
  value       = oci_database_autonomous_database.poc.display_name
}

output "db_state" {
  description = "Current state of the database"
  value       = oci_database_autonomous_database.poc.state
}

output "db_ocid" {
  description = "OCID of the database (unique ID in OCI)"
  value       = oci_database_autonomous_database.poc.id
}

output "compartment_id" {
  description = "OCID of the created compartment"
  value       = oci_identity_compartment.poc.id
}

output "connection_strings" {
  description = "Connection strings to connect to the database from applications"
  value = {
    high      = oci_database_autonomous_database.poc.connection_strings[0].high
    medium    = oci_database_autonomous_database.poc.connection_strings[0].medium
    low       = oci_database_autonomous_database.poc.connection_strings[0].low
    tp        = oci_database_autonomous_database.poc.connection_strings[0].all_connection_strings["TP"]
    tpurgent  = oci_database_autonomous_database.poc.connection_strings[0].all_connection_strings["TPURGENT"]
  }
}

output "sql_dev_web_url" {
  description = "URL to access SQL Developer Web"
  value       = oci_database_autonomous_database.poc.connection_urls[0].sql_dev_web_url
}

output "apex_url" {
  description = "URL to access APEX (Oracle Application Express)"
  value       = oci_database_autonomous_database.poc.connection_urls[0].apex_url
}
