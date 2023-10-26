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
  instance_name     = "${var.prefix}-testinstance"
  access_tags       = var.access_tags
  region            = var.region
  plan              = "standard"
  tags              = var.resource_tags
  environment_crn   = var.environment_crn
  service_endpoints = var.service_endpoints
  database_config   = var.database_config
}

# ACL profile
module "profile" {
  source = "git::https://github.ibm.com/GoldenEye/acl-profile-ocp.git?ref=1.3.0"
}

##############################################################################
# Configure VPE
##############################################################################


module "vpc" {
  depends_on = [
    module.create_cloudant.cloudant_instance
  ]
  source            = "git::https://github.ibm.com/GoldenEye/vpc-module.git?ref=6.3.0"
  unique_name       = "${var.prefix}-vpc"
  ibm_region        = var.region
  resource_group_id = module.resource_group.resource_group_id
  acl_rules_map = {
    private = concat(module.profile.base_acl, module.profile.https_acl, module.profile.deny_all_acl)
  }
  virtual_private_endpoints = {
    cloudant : module.create_cloudant.crn
  }
  vpc_tags = var.resource_tags
}
