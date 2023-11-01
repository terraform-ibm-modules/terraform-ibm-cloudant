module "cloudant" {
  source                        = "../../"
  resource_group_id             = var.resource_group_id
  instance_name                 = var.instance_name
  region                        = var.region
  skip_iam_authorization_policy = var.skip_iam_authorization_policy
  service_endpoints             = var.service_endpoints
  kms_encryption_enabled        = var.kms_encryption_enabled
  existing_kms_instance_guid    = var.existing_kms_instance_guid
  kms_key_crn                   = var.kms_key_crn
  backup_encryption_key_crn     = null # Need to use default encryption until ICD adds HPCS support for backup encryption
  tags                          = var.tags
  access_tags                   = var.access_tags
  cbr_rules                     = var.cbr_rules
  capacity                      = var.capacity
  environment_crn               = var.environment_crn
  legacy_credentials            = var.legacy_credentials
  include_data_events           = var.include_data_events
}
