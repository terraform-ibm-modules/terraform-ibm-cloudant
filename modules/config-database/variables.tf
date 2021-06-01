
variable "is_dr_provision" {
  type        = bool
  description = "Would you like to provision a new cloudant instance (true/false)"
  default     = true
}

variable "pri_resource_host" {
  description = "The host URL for the key"
  type        = string
}

variable "dr_resource_host" {
  description = "The host URL for the key"
  type        = string
}

variable "pri_resource_apikey" {
  description = "The API key for the credentials"
  type        = string
}

variable "dr_resource_apikey" {
  description = "The API key for the credentials"
  type        = string
}

variable "pri_resource_username" {
  description = "The username for the key"
  type        = string
}

variable "dr_resource_username" {
  description = "The username for the key"
  type        = string
}

variable "pri_resource_password" {
  description = "The password for the key"
  type        = string
}

variable "dr_resource_password" {
  description = "The password for the key"
  type        = string
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "is_partitioned" {
  description = "To set whether the database is partitioned"
  default     = false
}
