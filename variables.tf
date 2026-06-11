variable "tenancy_ocid" {
  description = "OCID of the OCI tenancy"
  type        = string
}

variable "user_ocid" {
  description = "OCID of the OCI user"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint of the API key"
  type        = string
}

variable "private_key_path" {
  description = "Path to the OCI API private key PEM file"
  type        = string
}

variable "region" {
  description = "OCI region"
  type        = string
}

variable "db_version" {
  description = "Database version (19c, 23ai, 26ai)"
  type        = string
  default     = "19c"
}

variable "db_password" {
  description = "Password for the admin user (minimum 12 characters)"
  type        = string
  sensitive   = true
}