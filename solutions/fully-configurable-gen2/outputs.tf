###############################################################################
# Outputs
###############################################################################

output "instance_name" {
  description = "Cloudant instance name"
  value       = module.cloudant.instance_name
}

output "instance_id" {
  description = "Cloudant instance id"
  value       = module.cloudant.instance_id
}

output "instance_guid" {
  description = "Cloudant instance guid"
  value       = module.cloudant.instance_guid
}

output "plan" {
  description = "Cloudant instance plan"
  value       = module.cloudant.plan
}

output "crn" {
  description = "Cloudant instance crn"
  value       = module.cloudant.crn
}

output "instance_url" {
  description = "Cloudant instance dashboard URL"
  value       = module.cloudant.instance_url
}

output "resource_group_name" {
  description = "Cloudant instance resource group name"
  value       = module.cloudant.resource_group_name
}

output "state" {
  description = "Cloudant instance state"
  value       = module.cloudant.state
}

output "capacity" {
  description = "Cloudant instance capacity"
  value       = module.cloudant.capacity
}

output "resource_keys_url" {
  description = "Cloudant instance resource keys URL"
  value       = module.cloudant.resource_keys_url
}

output "public_endpoint" {
  description = "Cloudant public endpoint"
  value       = module.cloudant.public_endpoint
}

output "private_endpoint" {
  description = "Cloudant private endpoint"
  value       = module.cloudant.private_endpoint
}

output "db_map" {
  description = "Cloudant database map"
  value       = module.cloudant.db_map
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = module.cloudant.service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = module.cloudant.service_credentials_object
  sensitive   = true
}

output "secrets_manager_secrets" {
  description = "Service credential secrets"
  value       = length(local.service_credential_secrets) > 0 ? module.secrets_manager_service_credentials[0].secrets : null
}
