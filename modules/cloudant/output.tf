#####################################################
# Cloudant
# Copyright 2021 IBM
#####################################################

output "cloudant_key_id" {
  description = "The ID of the cloudant key"
  value       = concat(ibm_resource_key.resourceKey.*.id, [""])[0]
}

output "cloudant_guid" {
  description = "The GUID of the cloudant instance"
  value       = ibm_resource_instance.cloudant_instance.guid
}

output "cloudant_id" {
  description = "The ID of the cloudant instance"
  value       = ibm_resource_instance.cloudant_instance.id
}