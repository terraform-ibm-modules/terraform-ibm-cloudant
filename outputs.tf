###############################################################################
# Outputs
###############################################################################

output "instance_name" {
  description = "Name of the cloudant instance"
  value       = ibm_cloudant.cloudant_instance.name
}

output "instance_id" {
  description = "The id of the cloudant instance created"
  value       = ibm_cloudant.cloudant_instance.id
}

output "instance_guid" {
  description = "Global identifier of the cloudant instance created"
  value       = ibm_cloudant.cloudant_instance.guid
}

output "plan" {
  description = "The plan used to create cloudant instance"
  value       = ibm_cloudant.cloudant_instance.plan
}

output "crn" {
  description = "CRN of the resource instance"
  value       = ibm_cloudant.cloudant_instance.crn
}

output "instance_url" {
  description = "The dashboard URL to access resource"
  value       = ibm_cloudant.cloudant_instance.dashboard_url
}

output "resource_group_name" {
  description = "The resource group name in which resource is provisioned"
  value       = ibm_cloudant.cloudant_instance.resource_group_name
}

output "state" {
  description = "The current state of the instance"
  value       = ibm_cloudant.cloudant_instance.state
}

output "capacity" {
  description = "A number of blocks of throughput units"
  value       = ibm_cloudant.cloudant_instance.capacity
}

output "resource_keys_url" {
  description = "The relative path to the resource keys for the instance"
  value       = ibm_cloudant.cloudant_instance.resource_keys_url
}

output "public_endpoint" {
  description = "The external public endpoint"
  value       = contains(keys(ibm_cloudant.cloudant_instance.extensions), "endpoints.public") ? ibm_cloudant.cloudant_instance.extensions["endpoints.public"] : null
}

output "private_endpoint" {
  description = "The external private endpoint"
  value       = contains(keys(ibm_cloudant.cloudant_instance.extensions), "endpoints.private") ? ibm_cloudant.cloudant_instance.extensions["endpoints.private"] : null
}

output "db_map" {
  description = "A map of the Cloudant database names created and their respective IDs"
  value       = { for database in ibm_cloudant_database.cloudant_database : database.db => database.id }
}
