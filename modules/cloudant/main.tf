locals {
  bind = var.bind_resource_key
}

resource "ibm_resource_instance" "cloudant_instance" {
  name              = var.instance_name
  service           = "cloudantnosqldb"
  plan              = var.plan
  location          = var.region
  resource_group_id = var.resource_group_id
  parameters        = (var.parameters != null ? var.parameters : null)
  tags              = (var.tags != null ? var.tags : [])
  service_endpoints = (var.service_endpoints != "" ? var.service_endpoints : null)


  //User can increase timeouts
  timeouts {
    create = (var.create_timeout != null ? var.create_timeout : null)
    update = (var.update_timeout != null ? var.update_timeout : null)
    delete = (var.delete_timeout != null ? var.delete_timeout : null)
  }
}

//Create new service credentials with auto-generated service id
resource "ibm_resource_key" "resourceKey" {
  count                = local.bind ? 1 : 0
  name                 = var.resource_key_name
  role                 = var.role
  resource_instance_id = ibm_resource_instance.cloudant_instance.id
  tags                 = (var.resource_key_tags != null ? var.resource_key_tags : [])
}