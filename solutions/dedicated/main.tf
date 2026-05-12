module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
<<<<<<< HEAD
  version                      = "1.5.0"
=======
  version                      = "1.6.0"
>>>>>>> 0b913e47cc5e1431e1e0d0902199c60b89663380
  resource_group_name          = var.existing_resource_group == false ? var.resource_group_name : null
  existing_resource_group_name = var.existing_resource_group == true ? var.resource_group_name : null
}

module "cloudant" {
  source              = "../../modules/fscloud"
  resource_group_id   = module.resource_group.resource_group_id
  instance_name       = var.instance_name
  region              = var.region
  tags                = var.tags
  access_tags         = var.access_tags
  enable_cors         = var.enable_cors
  allow_credentials   = var.allow_credentials
  origins             = var.origins
  capacity            = var.capacity
  environment_crn     = var.environment_crn
  include_data_events = var.include_data_events
  database_config     = var.database_config
}
