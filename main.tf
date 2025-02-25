##############################################################################
# Standard Cloudant Instance
##############################################################################
resource "ibm_cloudant" "cloudant_instance" {
  name     = var.instance_name
  location = var.region
  plan     = var.plan

  legacy_credentials  = var.legacy_credentials  # switch authentication between IAM legacy credentials
  include_data_events = var.include_data_events # Sends data event types to Activity Tracker with LogDNA
  capacity            = var.capacity
  resource_group_id   = var.resource_group_id
  enable_cors         = var.enable_cors
  tags                = var.tags
  service_endpoints   = var.service_endpoints
  environment_crn     = var.environment_crn

  cors_config {
    allow_credentials = var.allow_credentials
    origins           = var.origins
  }

  timeouts {
    create = "120m" # Extending provisioning time to 120 minutes
  }

  lifecycle {
    # Ignore changes to these as a change will destroy and recreate the instance
    ignore_changes = [
      legacy_credentials,
      environment_crn,
      resource_group_id,
      location
    ]
  }
}

##############################################################################
# Attach access tags
##############################################################################

resource "ibm_resource_tag" "access_tags" {
  count       = length(var.access_tags) == 0 ? 0 : 1
  resource_id = ibm_cloudant.cloudant_instance.crn
  tags        = var.access_tags
  tag_type    = "access"
}

#############################################################################
# Create database in cloudant instance
##############################################################################

resource "ibm_cloudant_database" "cloudant_database" {
  count        = length(var.database_config)
  db           = var.database_config[count.index].db
  partitioned  = var.database_config[count.index].partitioned
  shards       = var.database_config[count.index].shards
  instance_crn = ibm_cloudant.cloudant_instance.crn

}
