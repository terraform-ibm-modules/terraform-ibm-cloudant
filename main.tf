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

  dynamic "cors_config" {
    for_each = var.enable_cors ? [1] : []
    content {
      allow_credentials = var.allow_credentials
      origins           = var.origins
    }
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

data "ibm_iam_access_tag" "access_tag" {
  for_each = length(var.access_tags) != 0 ? toset(var.access_tags) : []
  name     = each.value
}

resource "ibm_resource_tag" "access_tags" {
  depends_on  = [data.ibm_iam_access_tag.access_tag]
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

##############################################################################
# Service Credentials
##############################################################################

resource "ibm_resource_key" "service_credentials" {
  for_each             = { for key in var.service_credential_names : key.name => key }
  name                 = each.key
  role                 = each.value.role
  resource_instance_id = ibm_cloudant.cloudant_instance.id
  parameters = {
    service-endpoints = each.value.endpoint
  }
}

locals {
  # used for output only
  service_credentials_json = length(var.service_credential_names) > 0 ? {
    for service_credential in ibm_resource_key.service_credentials :
    service_credential["name"] => service_credential["credentials_json"]
  } : null

  service_credentials_object = length(var.service_credential_names) > 0 ? {
    host = ibm_resource_key.service_credentials[
      var.service_credential_names[0].name
    ].credentials["host"]
    url = ibm_resource_key.service_credentials[
      var.service_credential_names[0].name
    ].credentials["url"]
    credentials = {
      for rk in ibm_resource_key.service_credentials :
      rk.name => merge(
        {
          apikey                 = rk.credentials["apikey"]
          host                   = rk.credentials["host"]
          url                    = rk.credentials["url"]
          username               = rk.credentials["username"]
          iam_apikey_description = rk.credentials["iam_apikey_description"]
          iam_apikey_id          = rk.credentials["iam_apikey_id"]
          iam_apikey_name        = rk.credentials["iam_apikey_name"]
          iam_role_crn           = rk.credentials["iam_role_crn"]
          iam_serviceid_crn      = rk.credentials["iam_serviceid_crn"]
        },
        var.legacy_credentials ? {
          password = rk.credentials["password"]
          port     = rk.credentials["port"]
        } : {}
      )
    }
  } : null
}
