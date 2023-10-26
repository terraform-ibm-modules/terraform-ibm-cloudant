locals {
  validate_sm_region_cnd = var.existing_sm_instance_guid != null && var.existing_sm_instance_region == null
  validate_sm_region_msg = "existing_sm_instance_region must also be set when value given for existing_sm_instance_guid."
  # tflint-ignore: terraform_unused_declarations
  validate_sm_region_chk = regex(
    "^${local.validate_sm_region_msg}$",
    (!local.validate_sm_region_cnd
      ? local.validate_sm_region_msg
  : ""))

  sm_guid   = var.existing_sm_instance_guid == null ? ibm_resource_instance.secrets_manager[0].guid : var.existing_sm_instance_guid
  sm_region = var.existing_sm_instance_region == null ? var.region : var.existing_sm_instance_region
}

##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.0"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# Standard Cloudant Instance with IAM authentication
##############################################################################

module "create_cloudant" {
  source            = "../.."
  resource_group_id = module.resource_group.resource_group_id
  instance_name     = "${var.prefix}-cloudant"
  region            = local.sm_region
  plan              = "standard"
  tags              = var.resource_tags
}

##############################################################################
## Layering IAM access groups for the Cloudant instance.
## Note that you may want to use https://github.ibm.com/GoldenEye/role-based-access-groups-module
##############################################################################

resource "ibm_iam_access_group" "access_group" {
  name        = "${var.prefix}-cloudant-managers"
  description = "IAM Access group for Cloudant"
}

resource "ibm_iam_access_group_policy" "distributed_access_policy" {
  access_group_id = ibm_iam_access_group.access_group.id
  roles           = ["Manager", "Administrator"]

  resources {
    service              = "cloudantnosqldb"
    resource_instance_id = element(split(":", module.create_cloudant.instance_guid), 7)
  }
}

##############################################################################
## Create ServiceId with access to Cloudant instance, via the access group
## created above
##############################################################################

resource "ibm_iam_service_id" "cloudant_manager" {
  name        = "${var.prefix}-cloudant-manager"
  description = "ServiceID that has got manager and operator roles on the Cloudant instance"
}

resource "ibm_iam_access_group_members" "accgroupmem" {
  access_group_id = ibm_iam_access_group.access_group.id
  iam_service_ids = [ibm_iam_service_id.cloudant_manager.id]
}

########################################
## Create Secrets Manager layer
########################################

# Create Secrets Manager Instance
resource "ibm_resource_instance" "secrets_manager" {
  count             = var.existing_sm_instance_guid == null ? 1 : 0
  name              = "${var.prefix}-sm" #checkov:skip=CKV_SECRET_6: does not require high entropy string as is static value
  service           = "secrets-manager"
  service_endpoints = "public-and-private"
  plan              = "trial"
  location          = local.sm_region
  resource_group_id = module.resource_group.resource_group_id
  tags              = var.resource_tags

  timeouts {
    create = "30m" # Extending provisioning time to 30 minutes
  }
}

# Add a Secrets Group to the secret manager instance
module "secrets_manager_group" {
  source                   = "terraform-ibm-modules/secrets-manager-secret-group/ibm"
  version                  = "1.1.0"
  region                   = local.sm_region
  secrets_manager_guid     = local.sm_guid
  secret_group_name        = "${var.prefix}-cloudant-secrets"
  secret_group_description = "service secret-group"
}

# Note: Source need to be updated after migrating iam-serviceid-apikey-secrets-manager-module to public. Internal issue is being tracked here: https://github.ibm.com/GoldenEye/issues/issues/6299

##################################################################
## Configure Secret Manager to generate and rotate API Key for the Service ID created above
##################################################################

#module "dynamic_cloudant_serviceid_apikey" {
#  source                               = "git::https://github.ibm.com/GoldenEye/iam-serviceid-apikey-secrets-manager-module?ref=2.0.1"
#  region                               = local.sm_region
#  sm_iam_secret_name                   = "${var.prefix}-cloudant"
#  sm_iam_secret_description            = "Dynamic IAM secret / apikey"
#  serviceid_id                         = ibm_iam_service_id.cloudant_manager.id
#  secrets_manager_guid                 = local.sm_guid
#  secret_group_id                      = module.secrets_manager_group.secret_group_id
#  sm_iam_secret_auto_rotation          = true
#  sm_iam_secret_auto_rotation_interval = 85
#  sm_iam_secret_auto_rotation_unit     = "day"
#}
