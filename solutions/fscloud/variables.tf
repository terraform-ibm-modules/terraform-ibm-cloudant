variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
}

variable "region" {
  type        = string
  description = "The IBM Cloud region where the Cloudant instance will be provisioned."
  default     = "us-south"
}

variable "resource_group_id" {
  description = "The Id of an existing IBM Cloud resource group where the instance will be grouped."
  type        = string
  default     = null
}

variable "existing_resource_group" {
  type        = string
  description = "An existing resource group name to use."
  default     = null
}

variable "resource_group_name" {
  type        = string
  description = "New resource group name to use."
  default     = null
}

variable "instance_name" {
  description = "The name of the Cloudant instance"
  type        = string
}

variable "include_data_events" {
  type        = bool
  description = "Include data event types in events sent to IBM Cloud Activity Tracker. If set to false, only management events will be sent to Activity Tracker."
  default     = false
}

variable "capacity" {
  type        = number
  description = "Number of blocks of throughput units. See https://cloud.ibm.com/docs/Cloudant?topic=Cloudant-ibm-cloud-public#provisioned-throughput-capacity."
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
  description = "CRN of the IBM Cloudant Dedicated Hardware plan instance to provision a cloudant instance"
  type        = string
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
