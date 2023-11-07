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
# FSCloud compliant cloudant instance + database
##############################################################################

module "create_cloudant" {
  source            = "../../profiles/fscloud"
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

##############################################################################
# Configure VPE
##############################################################################

resource "ibm_is_vpc" "vpc" {
  name                        = "${var.prefix}-vpc"
  resource_group              = module.resource_group.resource_group_id
  default_network_acl_name    = "${var.prefix}-edge-acl"
  default_security_group_name = "${var.prefix}-default-sg"
  default_routing_table_name  = "${var.prefix}-default-table"
  tags                        = var.resource_tags
}

resource "ibm_is_subnet" "subnet" {
  name           = "${var.prefix}-subnet-1"
  vpc            = module.resource_group.resource_group_id
  resource_group = var.resource_group
  zone           = "${var.region}-1"
  tags           = var.resource_tags
}

resource "ibm_is_virtual_endpoint_gateway" "cloudant_endpoint" {

  name = "${var.prefix}-cloudant-endpoint"
  target {
    crn           = module.create_cloudant.crn
    resource_type = "provider_cloud_service"
  }
  vpc            = ibm_is_vpc.vpc.id
  resource_group = module.resource_group.resource_group_id
}
