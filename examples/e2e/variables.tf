#####################################################
# Cloudant - database
# Copyright 2021 IBM
#####################################################

#####################################################
# IBMCLOUD Cloudant Instance Variables
#####################################################
variable "provision" {
  description = "Enable this to provision the cloudant instance (true/false)"
  type        = bool
  default     = true
}

variable "provision_resource_key" {
  description = "Enable this to bind key to cloudant instance (true/false)"
  type        = bool
  default     = true
}

variable "pri_region" {
  description = "Provisioning Region for primary instance"
  type        = string
}

variable "dr_region" {
  description = "Provisioning Region for DR instance"
  type        = string
}

variable "pri_instance_name" {
  description = "Name of the cloudant instance for primary"
  type        = string
}

variable "dr_instance_name" {
  description = "Name of the cloudant instance for DR"
  type        = string
}

variable "pri_resource_key" {
  description = "Name of the resource key of the primary instance"
  type        = string
}

variable "dr_resource_key" {
  description = "Name of the resource key of the DR"
  type        = string
}

variable "pri_rg_name" {
  type        = string
  description = "Enter resource group name for primary instance"
  default     = "default"
}

variable "dr_rg_name" {
  type        = string
  description = "Enter resource group name for disaster recovery"
  default     = "default"
}

variable "legacy_credentials" {
  description = "Legacy authentication method for cloudant"
  type        = bool
  default     = null
}

variable "plan" {
  description = "plan type (standard and lite)"
  type        = string
}

variable "create_timeout" {
  type        = string
  description = "Timeout duration for create."
  default     = null
}

variable "update_timeout" {
  type        = string
  description = "Timeout duration for update."
  default     = null
}

variable "delete_timeout" {
  type        = string
  description = "Timeout duration for delete."
  default     = null
}

variable "parameters" {
  type        = map(string)
  description = "Arbitrary parameters to pass"
  default     = null
}

variable "service_endpoints" {
  description = "Types of the service endpoints. Possible values are 'public', 'private', 'public-and-private'."
  type        = string
  default     = null
}

variable "tags" {
  type        = list(string)
  description = "Tags that should be applied to the service"
  default     = null
}

variable "role" {
  description = "Resource key role"
  type        = string
}

variable "resource_key_tags" {
  type        = list(string)
  description = "Tags that should be applied to the service"
  default     = null
}

#####################################################
# IBMCLOUD Cloudant Service Policy Variables
#####################################################

variable "service_policy_provision" {
  description = "Enable this to provision the service policy (true/false)"
  type        = bool
}

variable "service_name" {
  description = "Name of the service ID"
  type        = string
}

variable "description" {
  description = "Description to service ID"
  type        = string
  default     = null
}

variable "roles" {
  description = "service policy roles"
  type        = list(string)
}


#####################################################
# IBMCLOUD Cloudant Database Variables
#####################################################

variable "is_dr_provision" {
  type        = bool
  description = "Would you like to provision a DR cloudant instance (true/false)"
  default     = true
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "is_partitioned" {
  default = false
}
