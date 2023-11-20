###############################################################################
# Outputs
###############################################################################

output "instance_name" {
  description = "Name of the IBM Cloudant instance"
  value       = module.cloudant.instance_name
}

output "instance_id" {
  description = "ID of the IBM Cloudant instance"
  value       = module.cloudant.instance_id
}

output "instance_guid" {
  description = "Global identifier of the IBM Cloudant instance"
  value       = module.cloudant.instance_guid
}

output "plan" {
  description = "Plan used to create the IBM Cloudant instance"
  value       = module.cloudant.plan
}

output "crn" {
  description = "CRN of the resource instance"
  value       = module.cloudant.crn
}

output "instance_url" {
  description = "Dashboard URL to access resources"
  value       = module.cloudant.instance_url
}

output "resource_group_name" {
  description = "Name of the resource group where the resource is provisioned"
  value       = module.cloudant.resource_group_name
}

output "state" {
  description = "Current state of the instance"
  value       = module.cloudant.state
}

output "capacity" {
  description = "Number of blocks of throughput units"
  value       = module.cloudant.capacity
}

output "resource_keys_url" {
  description = "Relative path to the resource keys for the instance"
  value       = module.cloudant.resource_keys_url
}

output "private_endpoint" {
  description = "External private endpoint"
  value       = module.cloudant.private_endpoint
}

output "db_map" {
  description = "IBM Cloudant database names and their IDs"
  value       = module.cloudant.db_map
}
