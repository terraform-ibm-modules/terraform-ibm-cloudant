variable "ibmcloud_api_key" {
  description = "The IBM Cloud API key to deploy IAM-enabled resources."
  type        = string
  sensitive   = true
}

variable "region" {
  type        = string
  description = "The IBM Cloud region where the Cloudant instance will be provisioned."
  default     = "us-south"
}

variable "existing_resource_group" {
  type        = bool
  description = "Whether to use an existing resource group."
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of a new or an existing resource group in which to provision the Cloudant instance."
}

variable "instance_name" {
  description = "The name of the IBM Cloudant instance."
  type        = string
}

variable "allow_credentials" {
  description = "Boolean value to allow authentication credentials. This is only used if enable_cors is set to true."
  type        = bool
  default     = true
}

variable "origins" {
  description = "An array of strings that contain allowed origin domains. This value is only used if enable_cors is set to true."
  type        = list(string)
  default     = []
}

variable "enable_cors" {
  description = "Boolean value to enable cross-origin resource sharing (CORS)."
  type        = bool
  default     = false
}

variable "include_data_events" {
  type        = bool
  description = "Whether to include data event types in events that are sent to IBM Cloud Activity Tracker."
  default     = false
}

variable "capacity" {
  type        = number
  description = "The number of blocks of throughput units."
  default     = 1
}

variable "access_tags" {
  type        = list(string)
  description = "Add access management tags to the Cloudant instance to control access."
  default     = []
}

variable "tags" {
  type        = list(string)
  description = "Add user resource tags to the Cloudant instance to organize, track, and manage costs."
  default     = []
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

variable "service_credential_names" {
  type = list(object({
    name     = string
    role     = optional(string, "Reader")
    endpoint = optional(string, "private")
  }))
  description = "List of service credentials to create for the Cloudant instance, including name and optionally role and endpoint type."
  default     = []
}

variable "provider_visibility" {
  description = "Set the visibility value for the IBM terraform provider. Supported values are `public`, `private`, `public-and-private`."
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private", "public-and-private"], var.provider_visibility)
    error_message = "Invalid visibility option. Allowed values are 'public', 'private', or 'public-and-private'."
  }
}
