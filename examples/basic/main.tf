##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.2.1"
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
  tags              = var.resource_tags
  database_config = [{
    db          = "cloudant-db"
    partitioned = false
    shards      = 16
  }]
}
