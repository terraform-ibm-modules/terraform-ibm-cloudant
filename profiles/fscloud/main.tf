module "cloudant" {
  source              = "../../"
  resource_group_id   = var.resource_group_id
  instance_name       = var.instance_name
  region              = var.region
  plan                = var.plan
  service_endpoints   = var.service_endpoints
  tags                = var.tags
  access_tags         = var.access_tags
  capacity            = var.capacity
  environment_crn     = var.environment_crn
  legacy_credentials  = var.legacy_credentials
  include_data_events = var.include_data_events
  database_config     = var.database_config
}
