#####################################################
# Cloudant Database
# Copyright 2021 IBM
#####################################################

provider "ibm" {
}

locals {
  parameters = {
    legacyCredentials = (var.legacy_credentials != null ? var.legacy_credentials : null)
  }
}

data "ibm_resource_group" "pri_group" {
  name = var.pri_rg_name
}

data "ibm_resource_group" "dr_group" {
  name = var.dr_rg_name
}

module "cloudant-instance-pri" {
  //Uncomment the following line to point the source to registry level
  //source = "terraform-ibm-modules/cloudant/ibm//modules/instance"

  source                 = "../../modules/instance"
  provision              = var.provision
  provision_resource_key = var.provision_resource_key
  instance_name          = var.pri_instance_name
  resource_group_id      = data.ibm_resource_group.pri_group.id
  plan                   = var.plan
  region                 = var.pri_region
  service_endpoints      = var.service_endpoints
  parameters             = local.parameters
  tags                   = var.tags
  create_timeout         = var.create_timeout
  update_timeout         = var.update_timeout
  delete_timeout         = var.delete_timeout
  resource_key_name      = var.pri_resource_key
  role                   = var.role
  resource_key_tags      = var.resource_key_tags

  ###################
  # Service Policy
  ###################
  service_policy_provision = var.service_policy_provision
  service_name             = var.service_name
  description              = var.description
  roles                    = var.roles
}

module "cloudant-instance-dr" {
  //Uncomment the following line to point the source to registry level
  //source = "terraform-ibm-modules/cloudant/ibm//modules/instance"

  count                  = var.is_dr_provision ? 1 : 0
  source                 = "../../modules/instance"
  provision_resource_key = var.provision_resource_key
  instance_name          = var.dr_instance_name
  resource_group_id      = data.ibm_resource_group.pri_group.id
  plan                   = var.plan
  region                 = var.dr_region
  service_endpoints      = var.service_endpoints
  parameters             = local.parameters
  tags                   = var.tags
  create_timeout         = var.create_timeout
  update_timeout         = var.update_timeout
  delete_timeout         = var.delete_timeout
  resource_key_name      = var.dr_resource_key
  role                   = var.role
  resource_key_tags      = var.resource_key_tags

  ###################
  # Service Policy
  ###################
  service_policy_provision = var.service_policy_provision
  service_name             = var.service_name
  description              = var.description
  roles                    = var.roles
}

module "cloudant-database" {
  //Uncomment the following line to point the source to registry level
  //source = "terraform-ibm-modules/cloudant/ibm//modules/config-database"

  source                = "../../modules/config-database"
  is_dr_provision       = var.is_dr_provision
  pri_resource_host     = module.cloudant-instance-pri.cloudant_key_host
  dr_resource_host      = length(module.cloudant-instance-dr) > 0 ? module.cloudant-instance-dr.0.cloudant_key_host : ""
  pri_resource_username = module.cloudant-instance-pri.cloudant_key_username
  dr_resource_username  = length(module.cloudant-instance-dr) > 0 ? module.cloudant-instance-dr.0.cloudant_key_username : ""
  pri_resource_password = module.cloudant-instance-pri.cloudant_key_password
  dr_resource_password  = length(module.cloudant-instance-dr) > 0 ? module.cloudant-instance-dr.0.cloudant_key_password : ""
  pri_resource_apikey   = module.cloudant-instance-pri.cloudant_key_apikey
  dr_resource_apikey    = length(module.cloudant-instance-dr) > 0 ? module.cloudant-instance-dr.0.cloudant_key_apikey : ""
  is_partitioned        = var.is_partitioned
  db_name               = var.db_name
}