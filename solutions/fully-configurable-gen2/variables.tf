##############################################################################
# Input Variables
##############################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key to deploy resources."
  sensitive   = true
}

variable "existing_resource_group_name" {
  type        = string
  description = "The name of an existing resource group to provision the resources. [Learn more](https://cloud.ibm.com/docs/account?topic=account-rgs&interface=ui#create_rgs) about how to create a resource group."
  default     = "Default"
}

variable "prefix" {
  type        = string
  nullable    = true
  description = "The prefix to add to all resources that this solution creates (e.g `prod`, `test`, `dev`). To skip using a prefix, set this value to `null` or an empty string. [Learn more](https://terraform-ibm-modules.github.io/documentation/#/prefix.md)."

  validation {
    # - null and empty string is allowed
    # - Must not contain consecutive hyphens (--): length(regexall("--", var.prefix)) == 0
    # - Starts with a lowercase letter: [a-z]
    # - Contains only lowercase letters (a–z), digits (0–9), and hyphens (-)
    # - Must not end with a hyphen (-): [a-z0-9]
    condition = (var.prefix == null || var.prefix == "" ? true :
      alltrue([
        can(regex("^[a-z][-a-z0-9]*[a-z0-9]$", var.prefix)),
        length(regexall("--", var.prefix)) == 0
      ])
    )
    error_message = "Prefix must begin with a lowercase letter and may contain only lowercase letters, digits, and hyphens '-'. It must not end with a hyphen('-'), and cannot contain consecutive hyphens ('--')."
  }

  validation {
    # must not exceed 16 characters in length
    condition     = var.prefix == null || var.prefix == "" ? true : length(var.prefix) <= 16
    error_message = "Prefix must not exceed 16 characters."
  }
}


variable "name" {
  type        = string
  description = "The name of the Cloudant instance. If a prefix input variable is specified, the prefix is added to the name in the `<prefix>-<name>` format."
  default     = "cloudant"
}

variable "region" {
  description = "The region where you want to deploy your instance."
  type        = string
  default     = "eu-de"
}

variable "allow_credentials" {
  description = "Boolean value to allow authentication credentials. This is only used if `enable_cors` is set to `true`."
  type        = bool
  default     = true
}

variable "origins" {
  description = "An array of strings that contain allowed origin domains. This value is only used if `enable_cors` is set to `true`."
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
  description = "Include data event types in events sent to IBM Cloud Activity Tracker for the Cloudant instance."
  default     = false
}

variable "capacity" {
  type        = number
  description = "The number of blocks of throughput units."
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
  description = "A list of service credential resource keys to be created for the Cloudant instance."
  default     = []
}

variable "existing_secrets_manager_instance_crn" {
  type        = string
  default     = null
  description = "The CRN of existing Secrets Manager to use to create service credential secrets for the Cloudant instance."

  validation {
    condition = anytrue([
      var.existing_secrets_manager_instance_crn == null,
      can(regex("^crn:v\\d:(.*:){2}secrets-manager:(.*:)([aos]\\/[\\w_\\-]+):[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}::$", var.existing_secrets_manager_instance_crn))
    ])
    error_message = "The value provided for 'existing_secrets_manager_instance_crn' is not valid."
  }
}

variable "service_credential_secrets" {
  type = list(object({
    secret_group_name        = string
    secret_group_description = optional(string)
    existing_secret_group    = optional(bool)
    service_credentials = list(object({
      secret_name                                 = string
      service_credentials_source_service_role_crn = string
      secret_labels                               = optional(list(string))
      secret_auto_rotation                        = optional(bool)
      secret_auto_rotation_unit                   = optional(string)
      secret_auto_rotation_interval               = optional(number)
      service_credentials_ttl                     = optional(string)
      service_credential_secret_description       = optional(string)
    }))
  }))
  default     = []
  description = "Service credential secrets configuration for Cloudant."

  validation {
    condition = alltrue([
      for group in var.service_credential_secrets : alltrue([
        for credential in group.service_credentials : can(regex("^crn:v[0-9]:bluemix(:..*){2}(:.*){3}:(serviceRole|role):..*$", credential.service_credentials_source_service_role_crn))
      ])
    ])
    error_message = "service_credentials_source_service_role_crn must be a serviceRole CRN. See https://cloud.ibm.com/iam/roles"
  }

  validation {
    condition = (
      length(var.service_credential_secrets) == 0 ||
      var.existing_secrets_manager_instance_crn != null
    )
    error_message = "`existing_secrets_manager_instance_crn` is required when adding service credentials to a secrets manager secret."
  }
}

variable "skip_cloudant_secrets_manager_auth_policy" {
  type        = bool
  default     = false
  description = "Whether an IAM authorization policy is created for the Secrets Manager instance to create service credential secrets for the Cloudant instance. If set to `true`, an existing policy is used. The value is ignored if `existing_secrets_manager_instance_crn` is not passed."
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

variable "existing_secrets_manager_endpoint_type" {
  type        = string
  description = "The endpoint type to use if `existing_secrets_manager_instance_crn` is specified. Possible values: `public`, `private`."
  default     = "private"

  validation {
    condition     = contains(["public", "private"], var.existing_secrets_manager_endpoint_type)
    error_message = "Only \"public\" and \"private\" are allowed values for 'existing_secrets_manager_endpoint_type'."
  }
}
