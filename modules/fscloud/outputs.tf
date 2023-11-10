###############################################################################
# Outputs
###############################################################################

output "instance_name" {
  description = "Name of the cloudant instance"
  value       = module.cloudant.instance_name
}

output "instance_id" {
  description = "The id of the cloudant instance created"
  value       = module.cloudant.instance_id
}

output "instance_guid" {
  description = "Global identifier of the cloudant instance created"
  value       = module.cloudant.instance_guid
}

output "plan" {
  description = "The plan used to create cloudant instance"
  value       = module.cloudant.plan
}

output "crn" {
  description = "CRN of the resource instance"
  value       = module.cloudant.crn
}

output "instance_url" {
  description = "The dashboard URL to access resource"
  value       = module.cloudant.instance_url
}

output "resource_group_name" {
  description = "The resource group name in which resource is provisioned"
  value       = module.cloudant.resource_group_name
}

output "state" {
  description = "The current state of the instance"
  value       = module.cloudant.state
}

output "capacity" {
  description = "A number of blocks of throughput units"
  value       = module.cloudant.capacity
}

output "resource_keys_url" {
  description = "The relative path to the resource keys for the instance"
  value       = module.cloudant.resource_keys_url
}

output "private_endpoint" {
  description = "The external private endpoint"
  value       = module.cloudant.private_endpoint
}

output "db_map" {
  description = "A map of the Cloudant database names created and their respective IDs"
  value       = module.cloudant.db_map
}
