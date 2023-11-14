module "resource_group" {
  count                        = (var.resource_group_id == null) ? 1 : 0
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.1.0"
  resource_group_name          = var.existing_resource_group == false ? var.resource_group_name : null
  existing_resource_group_name = var.existing_resource_group == true ? var.resource_group_name : null
}

module "cloudant" {
  source              = "../../modules/fscloud"
  resource_group_id   = var.resource_group_id == null ? module.resource_group[0].resource_group_id : var.resource_group_id
  instance_name       = var.instance_name
  region              = var.region
  tags                = var.tags
  access_tags         = var.access_tags
  capacity            = var.capacity
  environment_crn     = var.environment_crn
  include_data_events = var.include_data_events
  database_config     = var.database_config
}

# Goal is to add existing resource group or a new resource  group
