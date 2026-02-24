variable "ibmcloud_api_key" {
  type        = string
  description = "APIkey that's associated with the account to use, set via environment variable TF_VAR_ibmcloud_api_key"
  sensitive   = true
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this example"
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this example"
  default     = "fs"
}

variable "access_tags" {
  type        = list(string)
  description = "Add access management tags to the Cloudant instance to control access. [Learn more](https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#tag-types)"
  default     = []
}

variable "resource_tags" {
  type        = list(string)
  description = "Add user resource tags to the Cloudant instance to organize, track, and manage costs. [Learn more](https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#tag-types)"
  default     = []
}

variable "database_config" {
  type = list(object({
    db          = string
    partitioned = optional(bool)
    shards      = optional(number)
  }))

  description = "(Optional, List) The databases with their corresponding partitioning and shards to be created in the cloudant instance"
  default = [{
    db          = "cloudant-dedicated-db"
    partitioned = false
    shards      = 16
  }]
}

variable "environment_crn" {
  description = "CRN of the IBM Cloudant Dedicated Hardware plan instance"
  type        = string

  validation {
    condition     = length(var.environment_crn) > 0
    error_message = "Dedicated environment CRN is required to create a standard cloudant instance."
  }
}
