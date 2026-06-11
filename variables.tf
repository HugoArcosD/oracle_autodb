variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "db_version" {
  default = "19c"
}

variable "db_password" {
  sensitive = true
}