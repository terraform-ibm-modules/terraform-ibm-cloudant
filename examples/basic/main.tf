##############################################################################
# Local
##############################################################################
locals {
  is_gen2       = can(regex("-gen2$", var.plan))
  endpoint_type = var.service_endpoints == "public-and-private" ? "private" : var.service_endpoints

  gen2_service_credential_names = [
    {
      name     = "cloudant_reader"
      role     = "Reader"
      endpoint = local.endpoint_type
    },
    {
      name     = "cloudant_manager"
      role     = "Manager"
      endpoint = local.endpoint_type
    },
    {
      name     = "cloudant_writer"
      role     = "Writer"
      endpoint = local.endpoint_type
    },
    {
      name     = "cloudant_monitor"
      role     = "Monitor"
      endpoint = local.endpoint_type
    },
    {
      name     = "cloudant_checkpointer"
      role     = "Checkpointer"
      endpoint = local.endpoint_type
    }
  ]

  classic_service_credential_names = [
    {
      name     = "cloudant_reader"
      endpoint = "private"
      role     = "Reader"
    },
    {
      name     = "cloudant_manager"
      role     = "Manager"
      endpoint = local.endpoint_type
    },
    {
      name     = "cloudant_writer"
      role     = "Writer"
      endpoint = local.endpoint_type
    },
  ]
}

##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.6.1"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# Basic cloudant instance + database
##############################################################################

module "create_cloudant" {
  source            = "../.."
  resource_group_id = module.resource_group.resource_group_id
  instance_name     = "${var.prefix}-testinstance"
  access_tags       = var.access_tags
  region            = var.region
  plan              = var.plan
  service_endpoints = var.service_endpoints
  tags              = var.resource_tags
  database_config = [{
    db          = "cloudant-db"
    partitioned = false
    shards      = 16
  }]
  service_credential_names = local.is_gen2 ? local.gen2_service_credential_names : local.classic_service_credential_names
}
