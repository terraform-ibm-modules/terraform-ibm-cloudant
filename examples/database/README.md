# Module cloudant database

This module is used to create cloudant instance and create primary & disaster recovery database.

## Example Usage
```

data "ibm_resource_group" "pri_group" {
  name = var.pri_rg_name
}

data "ibm_resource_group" "dr_group" {
  name = var.dr_rg_name
}

module "cloudant-instance-pri" {
  //Uncomment the following line to point the source to registry level
  //source = "terraform-ibm-modules/cloudant/ibm//modules/instance"

  source            = "../../modules/instance"
  provision         = var.provision
  bind_resource_key = var.bind_resource_key
  instance_name     = var.pri_instance_name
  resource_group_id = data.ibm_resource_group.pri_group.id
  plan              = var.plan
  region            = var.pri_region
  service_endpoints = var.service_endpoints
  parameters        = var.parameters
  tags              = var.tags
  create_timeout    = var.create_timeout
  update_timeout    = var.update_timeout
  delete_timeout    = var.delete_timeout
  resource_key_name = var.pri_resource_key
  role              = var.role
  resource_key_tags = var.resource_key_tags

  ###################
  # Service Policy
  ###################
  service_policy_provision = var.service_policy_provision
  service_name             = var.service_name
  description              = var.description
  roles                    = var.roles
}

...
...

module "cloudant-database" {
  //Uncomment the following line to point the source to registry level
  //source = "terraform-ibm-modules/cloudant/ibm//modules/config-database"

  source                = "../../modules/config-database"
  is_dr_provision       = var.is_dr_provision
  pri_resource_host     = var.pri_resource_host
  dr_resource_host      = var.dr_resource_host
  pri_resource_username = var.pri_resource_username
  dr_resource_username  = var.dr_resource_username
  pri_resource_password = var.pri_resource_password
  dr_resource_password  = var.dr_resource_password
  pri_resource_apikey   = var.pri_resource_apikey
  dr_resource_apikey    = var.dr_resource_apikey
  is_partitioned        = var.is_partitioned
  db_name               = var.db_name
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs


| Name                     | Description                                                                     | Type         | Default | Required |
|--------------------------|---------------------------------------------------------------------------------|:-------------|:------- |:---------|
| provision_resource_key   | Indicating that instance key should be bind to cloudant instance                | bool         | true    | no       |
| provision                | Indicating to provision a new cloudant instance                                 | bool         | true    | no       |
| is_dr_provision          | Indicating to provision DR database                                             | bool         | true    | no       |
| pri\_instance\_name      | A descriptive name used to identify the resource instance for primary           | string       | n/a     | yes      |
| dr\_instance\_name       | A descriptive name used to identify the resource instance for disaster recovery | string       | n/a     | yes      |
| pri\_resource\_key       | A descriptive name used to identify the resource key for primary                | string       | n/a     | yes      |
| dr\_resource\_key        | A descriptive name used to identify the resource key for disaster recovery      | string       | n/a     | yes      |
| db_name                  | Database name                                                                   | string       | n/a     | yes      |
| is_partitioned           | Enable partition database                                                       | bool         | false   | no       |
| role                     | Resource key role                                                               | string       | n/a     | yes      |
| plan                     | The name of the plan type supported by service.                                 | string       | n/a     | yes      |
| pri_region               | source location or environment to create the resource instance.                 | string       | n/a     | yes      |
| dr_region                | Target location or environment to create the resource instance.                 | string       | n/a     | yes      |
| pri\_resource\_group     | Name of the primary db resource group                                           | string       | n/a     | yes      |
| dr\_resource\_group      | Name of the disaster recovery db  resource group                                | string       | n/a     | yes      |
| service\_endpoints       | Possible values are 'public', 'private', 'public-and-private'.                  | string       | n/a     | no       |
| tags                     | Tags that should be applied to the service                                      | list(string) | n/a     | no       |
| resource_key_tags        | Tags that should be applied to the service key                                  | list(string) | n/a     | no       |
| parameters               | Arbitrary parameters to pass                                                    | map(string)  | n/a     | no       |
| service_policy_provision | Indicating to provision service policy                                          | bool         | true    | no       |
| service\_name            | A descriptive name used to identify the service policy                          | string       | n/a     | yes      |
| description              | Description to service ID                                                       | string       | n/a     | no       |
| create_timeout           | Timeout duration for create                                                     | string       | n/a     | no       |
| update_timeout           | Timeout duration for update                                                     | string       | n/a     | no       |
| delete_timeout           | Timeout duration for delete                                                     | string       | n/a     | no       |

NOTE: We can set the create, update and delete timeouts as string. For e.g say we want to set 15 minutes timeout then the value should be "15m".