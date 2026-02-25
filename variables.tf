variable "region" {
  type        = string
  description = "The IBM Cloud region where the Cloudant instance will be provisioned."
  default     = "us-south"

  validation {
    condition     = contains(["us-south", "us-east", "che01", "au-syd", "br-sao", "ca-tor", "eu-de", "eu-gb", "eu-es", "eu-fr2", "jp-osa", "jp-tok"], var.region)
    error_message = "Valid regions: us-south, us-east, che01, au-syd, br-sao, ca-tor, eu-de, eu-gb, eu-es, eu-fr2, jp-osa, jp-tok."
  }
}

variable "plan" {
  type        = string
  description = "The plan for the Cloudant instance. Standard or lite."
  default     = "standard"

  validation {
    condition     = contains(["standard", "lite"], var.plan)
    error_message = "Supported plans: standard or lite. Cloudant instance on dedicated host supports standard plan only."
  }

  validation {
    condition     = var.plan != "standard" && var.environment_crn != null ? false : true
    error_message = "Only standard plan is supported on a dedicated hardware instance"
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
  description = "Boolean value to allow authentication credentials. This will only be used if enable_cors is set to true."
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
  description = "Add access management tags to the Cloudant instance to control access. [Learn more](https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#create-access-console)."
  default     = []
}

variable "tags" {
  type        = list(string)
  description = "Add user resource tags to the Cloudant instance to organize, track, and manage costs. [Learn more](https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#tag-types)."
  default     = []

  validation {
    condition     = alltrue([for tag in var.tags : can(regex("^[A-Za-z0-9 _\\-.:]{1,128}$", tag))])
    error_message = "Each resource tag must be 128 characters or less and may contain only A-Z, a-z, 0-9, spaces, underscore (_), hyphen (-), period (.), and colon (:)."
  }
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
