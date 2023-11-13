module "cloudant" {
  source              = "../../modules/fscloud"
  resource_group_id   = var.resource_group_id
  instance_name       = var.instance_name
  region              = var.region
  tags                = var.tags
  access_tags         = var.access_tags
  capacity            = var.capacity
  environment_crn     = var.environment_crn
  include_data_events = var.include_data_events
  database_config     = var.database_config
}
