resource "oci_identity_compartment" "poc" {
  compartment_id = var.tenancy_ocid
  description    = "Terraform POC"
  name           = "terraform-poc"
}

resource "oci_database_autonomous_database" "poc" {

  compartment_id = oci_identity_compartment.poc.id

  db_name        = "POCDB"
  display_name   = "POCDB"
  db_version     = var.db_version
  admin_password = var.db_password

  cpu_core_count           = 1
  data_storage_size_in_tbs = 1

  db_workload = "OLTP"

  is_free_tier = true
}