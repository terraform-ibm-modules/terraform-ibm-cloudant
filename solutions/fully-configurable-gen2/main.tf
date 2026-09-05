#######################################################################################################################
# Local
#######################################################################################################################

locals {
  prefix = var.prefix != null ? trimspace(var.prefix) != "" ? "${var.prefix}-" : "" : ""
}

#######################################################################################################################
# Resource Group
#######################################################################################################################
module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.6.1"
  existing_resource_group_name = var.existing_resource_group_name
}

#######################################################################################################################
# Secrets management
#######################################################################################################################

locals {
  create_secrets_manager_auth_policy = var.skip_cloudant_secrets_manager_auth_policy || var.existing_secrets_manager_instance_crn == null ? 0 : 1
}

module "sm_instance_crn_parser" {
  count   = var.existing_secrets_manager_instance_crn != null ? 1 : 0
  source  = "terraform-ibm-modules/common-utilities/ibm//modules/crn-parser"
  version = "1.9.0"
  crn     = var.existing_secrets_manager_instance_crn
}

resource "ibm_iam_authorization_policy" "secrets_manager_key_manager" {
  count                       = local.create_secrets_manager_auth_policy
  source_service_name         = "secrets-manager"
  source_resource_instance_id = local.existing_secrets_manager_instance_guid
  target_service_name         = "cloudantnosqldb"
  target_resource_instance_id = module.cloudant.instance_guid
  roles                       = ["Key Manager"]
  description                 = "Allow Secrets Manager with instance id ${local.existing_secrets_manager_instance_guid} to manage key for the Cloudant instance"
}

resource "time_sleep" "wait_for_cloudant_authorization_policy" {
  count           = local.create_secrets_manager_auth_policy
  depends_on      = [ibm_iam_authorization_policy.secrets_manager_key_manager]
  create_duration = "30s"
  triggers = {
    secrets_manager_region = local.existing_secrets_manager_instance_region
    secrets_manager_guid   = local.existing_secrets_manager_instance_guid
  }
}

locals {
  service_credential_secrets = [
    for service_credentials in var.service_credential_secrets : {
      secret_group_name        = service_credentials.secret_group_name
      secret_group_description = service_credentials.secret_group_description
      existing_secret_group    = service_credentials.existing_secret_group
      secrets = [
        for secret in service_credentials.service_credentials : {
          secret_name                                 = secret.secret_name
          secret_labels                               = secret.secret_labels
          secret_auto_rotation                        = secret.secret_auto_rotation
          secret_auto_rotation_unit                   = secret.secret_auto_rotation_unit
          secret_auto_rotation_interval               = secret.secret_auto_rotation_interval
          service_credentials_ttl                     = secret.service_credentials_ttl
          service_credential_secret_description       = secret.service_credential_secret_description
          service_credentials_source_service_role_crn = secret.service_credentials_source_service_role_crn
          service_credentials_source_service_crn      = module.cloudant.crn
          secret_type                                 = "service_credentials"
        }
      ]
    }
  ]

  secrets                                  = local.service_credential_secrets
  existing_secrets_manager_instance_guid   = var.existing_secrets_manager_instance_crn != null ? module.sm_instance_crn_parser[0].service_instance : null
  existing_secrets_manager_instance_region = var.existing_secrets_manager_instance_crn != null ? module.sm_instance_crn_parser[0].region : null
}

module "secrets_manager_service_credentials" {
  count   = length(local.secrets) > 0 && var.existing_secrets_manager_instance_crn != null ? 1 : 0
  source  = "terraform-ibm-modules/secrets-manager/ibm//modules/secrets"
  version = "2.15.15"

  existing_sm_instance_guid   = local.create_secrets_manager_auth_policy > 0 ? time_sleep.wait_for_cloudant_authorization_policy[0].triggers["secrets_manager_guid"] : local.existing_secrets_manager_instance_guid
  existing_sm_instance_region = local.create_secrets_manager_auth_policy > 0 ? time_sleep.wait_for_cloudant_authorization_policy[0].triggers["secrets_manager_region"] : local.existing_secrets_manager_instance_region
  endpoint_type               = var.existing_secrets_manager_endpoint_type
  secrets                     = local.secrets
}

#######################################################################################################################
# Cloudant
#######################################################################################################################

module "cloudant" {
  source = "../.."

  resource_group_id        = module.resource_group.resource_group_id
  instance_name            = "${local.prefix}${var.name}"
  region                   = var.region
  plan                     = "standard-gen2"
  service_endpoints        = "private"
  tags                     = var.tags
  access_tags              = var.access_tags
  enable_cors              = var.enable_cors
  allow_credentials        = var.allow_credentials
  origins                  = var.origins
  capacity                 = var.capacity
  include_data_events      = var.include_data_events
  database_config          = var.database_config
  service_credential_names = var.service_credential_names
}
