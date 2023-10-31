###############################################################################
# Outputs
###############################################################################

output "instance_name" {
  description = "Name of the cloudant instance"
  value       = module.create_cloudant.instance_name
}

output "instance_id" {
  description = "The id of the cloudant instance created"
  value       = module.create_cloudant.instance_id
}

output "instance_guid" {
  description = "Global identifier of the cloudant instance created"
  value       = module.create_cloudant.instance_guid
}

output "crn" {
  description = "CRN of the resource instance"
  value       = module.create_cloudant.crn
}

output "instance_url" {
  description = "The dashboard URL to access resource"
  value       = module.create_cloudant.instance_url
}

output "resource_group_name" {
  description = "The resource group name in which resource is provisioned"
  value       = module.create_cloudant.resource_group_name
}

output "state" {
  description = "The current state of the instance"
  value       = module.create_cloudant.state
}

output "capacity" {
  description = "A number of blocks of throughput units"
  value       = module.create_cloudant.capacity
}

output "resource_keys_url" {
  description = "The relative path to the resource keys for the instance"
  value       = module.create_cloudant.resource_keys_url
}

output "db_map" {
  description = "A map of the Cloudant database names created and their respective IDs"
  value       = module.create_cloudant.db_map
}
