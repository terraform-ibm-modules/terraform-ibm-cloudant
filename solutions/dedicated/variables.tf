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
  description = "Whether to use an existing resource group."
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of a new or an existing resource group in which to provision the Cloudant instance in."
}

variable "instance_name" {
  description = "The name of the IBM Cloudant instance."
  type        = string
}

variable "allow_credentials" {
  description = "Boolean value to allow authentication credentials."
  type        = bool
  default     = true
}

variable "origins" {
  description = "An array of strings that contain allowed origin domains. "
  type        = list(string)
  default     = []
}

variable "enable_cors" {
  description = "Boolean value to enable CORS. The supported values are true and false."
  type        = bool
  default     = false
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
variable "provider_visibility" {
  description = "Set the visibility value for the IBM terraform provider. Supported values are `public`, `private`, `public-and-private`. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/guides/custom-service-endpoints)."
  type        = string
  default     = "private"

  validation {
    condition     = contains(["public", "private", "public-and-private"], var.provider_visibility)
    error_message = "Invalid visibility option. Allowed values are 'public', 'private', or 'public-and-private'."
  }
}
