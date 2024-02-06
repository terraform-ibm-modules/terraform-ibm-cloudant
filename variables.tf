variable "region" {
  type        = string
  description = "The IBM Cloud region where the Cloudant instance will be provisioned."
  default     = "us-south"
}

variable "plan" {
  type        = string
  description = "The plan for the Cloudant instance. Standard or lite."
  default     = "standard"

  validation {
    condition     = contains(["standard", "lite"], var.plan)
    error_message = "Supported plans: standard or lite. Cloudant instance on dedicated host supports standard plan only."
  }
}

variable "resource_group_id" {
  description = "The Id of an existing IBM Cloud resource group where the instance will be grouped."
  type        = string
}

variable "instance_name" {
  description = "The name of the Cloudant instance"
  type        = string
}

variable "allow_credentials" {
  description = "Boolean value to allow authentication credentials."
  type        = bool
  default     = true
}

variable "origins" {
  description = "An array of strings that contain allowed origin domains."
  type        = list(string)
  default     = []
}

variable "enable_cors" {
  description = "Boolean value to enable CORS. The supported values are true and false."
  type        = bool
  default     = true
}

variable "legacy_credentials" {
  type        = bool
  description = "Use both legacy credentials, in addition to IAM credentials for authentication. If set to false, use use only IAM credentials."
  default     = false # uses only IAM credentials
}

variable "include_data_events" {
  type        = bool
  description = "Include data event types in events sent to IBM Cloud Activity Tracker. If set to false, only management events will be sent to Activity Tracker."
  default     = false
}

variable "capacity" {
  type        = number
  description = "Number of blocks of throughput units. See https://cloud.ibm.com/docs/Cloudant?topic=Cloudant-ibm-cloud-public#provisioned-throughput-capacity. Capacity modification is not supported for lite plan."
  default     = 1
}

variable "access_tags" {
  type        = list(string)
  description = "List of access tags to be associated with the Cloudant instance"
  default     = []
}

variable "tags" {
  type        = list(string)
  description = "List of tags to be associated to cloudant instance"
  default     = []
}

variable "environment_crn" {
  description = "Optional CRN of the IBM Cloudant Dedicated Hardware plan instance to provision a cloudant instance"
  type        = string
  default     = null
}

variable "service_endpoints" {
  type        = string
  description = "Sets the endpoint of the instance, valid values are 'public', 'private', or 'public-and-private'"
  default     = "public-and-private"

  validation {
    condition     = can(regex("public|public-and-private|private", var.service_endpoints))
    error_message = "Valid values for service_endpoints are 'public', 'public-and-private', and 'private'"
  }
}

variable "database_config" {
  type = list(object({
    db          = string
    partitioned = optional(bool)
    shards      = optional(number)
  }))

  description = "(Optional, List) The databases with their corresponding partitioning and shards to be created in the cloudant instance"
  default     = []
}
