variable "ibmcloud_api_key" {
  description = "The IBM Cloud API key to deploy IAM-enabled resources."
  type        = string
  sensitive   = true
}

variable "region" {
  type        = string
  description = "The IBM Cloud region where the instance of IBM Cloudant is provisioned."
  default     = "us-south"
}

variable "existing_resource_group" {
  type        = bool
  description = "Whether to use an existing resource group. If false, specify the name for the new resource group in the `resource_group_name` input."
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "Add a new resource group with this name if the `existing_resource_group` input is false. To use an existing resource group, set `existing_resource_group` to true instead."
}

variable "instance_name" {
  description = "The name of the IBM Cloudant instance."
  type        = string
}

variable "include_data_events" {
  type        = bool
  description = "Whether to include data event types in events that are sent to IBM Cloud Activity Tracker. The emitted events are only of the `management` type."
  default     = false
}

variable "capacity" {
  type        = number
  description = "The number of blocks of throughput units. See [Provisioned throughput capacity](https://cloud.ibm.com/docs/Cloudant?topic=Cloudant-ibm-cloud-public#provisioned-throughput-capacity)."
  default     = 1
}

variable "access_tags" {
  type        = list(string)
  description = "The list of access tags to apply to the IBM Cloudant instance."
  default     = []
}

variable "tags" {
  type        = list(string)
  description = "The list of resource tags to apply to The IBM Cloudant instance."
  default     = []
}

variable "environment_crn" {
  description = "The CRN of the instance of the IBM Cloudant Dedicated Hardware plan to provision an IBM Cloudant instance."
  type        = string
}

variable "database_config" {
  type = list(object({
    db          = string
    partitioned = optional(bool)
    shards      = optional(number)
  }))

  description = "The databases to create in the IBM Cloudant instance with options to create partitions and shards."
  default     = []
}
