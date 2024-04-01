module "cloudant" {
  source              = "../../"
  resource_group_id   = var.resource_group_id
  instance_name       = var.instance_name
  region              = var.region
  plan                = "standard"
  service_endpoints   = "private"
  enable_cors         = var.enable_cors
  allow_credentials   = var.allow_credentials
  origins             = var.origins
  tags                = var.tags
  access_tags         = var.access_tags
  capacity            = var.capacity
  environment_crn     = var.environment_crn
  legacy_credentials  = false
  include_data_events = var.include_data_events
  database_config     = var.database_config
}
