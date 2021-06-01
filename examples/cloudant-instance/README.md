# Module cloudant instance

This module is used to create cloudant instance.

## Example Usage
```
data "ibm_resource_group" "cloudant" {
  name = var.resource_group
}

module "cloudant_instance" {
  //Uncomment the following line to point the source to registry level
  //source = "terraform-ibm-modules/cloudant/ibm//modules/cloudant-instance"

  source            = "../../modules/cloudant"
  bind_resource_key = var.bind_resource_key
  instance_name     = var.instance_name
  resource_group_id = data.ibm_resource_group.cloudant.id
  plan              = var.plan
  region            = var.region
  service_endpoints = var.service_endpoints
  parameters        = var.parameters
  tags              = var.tags
  create_timeout    = var.create_timeout
  update_timeout    = var.update_timeout
  delete_timeout    = var.delete_timeout
  resource_key_name = var.resource_key_name
  role              = var.role
  resource_key_tags = var.resource_key_tags
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs


| Name               | Description                                                      | Type         | Default | Required |
|--------------------|------------------------------------------------------------------|:-------------|:------- |:---------|
| instance\_name      | A descriptive name used to identify the resource instance       | string       | n/a     | yes      |
| bind_resource_key  | Indicating that instance key should be bind to logdna instance   | bool         | n/a     | no       |
| resource\_key\_name| A descriptive name used to identify the resource key             | string       | n/a     | yes      |
| role               | Name of the user role.                                           | string       | n/a     | yes      |
| plan               | The name of the plan type supported by service.                  | string       | n/a     | yes      |
| region             | Target location or environment to create the resource instance.  | string       | n/a     | yes      |
| resource\_group    | Name of the resource group                                       | string       | n/a     | yes      |
| service\_endpoints | Possible values are 'public', 'private', 'public-and-private'.   | string       | n/a     | no       |
| tags               | Tags that should be applied to the service                       | list(string) | n/a     | no       |
| resource_key_tags  | Tags that should be applied to the service key                   | list(string) | n/a     | no       |
| parameters         | Arbitrary parameters to pass                                     | map(string)  | n/a     | no       |
| create_timeout     | Timeout duration for create                                      | string       | n/a     | no       |
| update_timeout     | Timeout duration for update                                      | string       | n/a     | no       |
| delete_timeout     | Timeout duration for delete                                      | string       | n/a     | no       |

NOTE: We can set the create, update and delete timeouts as string. For e.g say we want to set 15 minutes timeout then the value should be "15m".