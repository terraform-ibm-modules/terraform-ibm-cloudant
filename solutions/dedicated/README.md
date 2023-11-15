# IBM Cloudant Dedicated on IBM Cloud Dedicated

Deployable Architecture for the dedicated IBM Cloudant instance which supports provisioning the following resources:

- A resource group, if one is not passed in.
- An IBM Cloudant Dedicated instance in IBM Cloud Dedicated
- A Cloudant database

## Before you begin

* You need an [IBM Cloudant Dedicated](https://cloud.ibm.com/docs/Cloudant?topic=Cloudant-ibm-cloud-dedicated) Hardware plan instance in order to provision the Cloudant instance in.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, <1.6.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | 1.59.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudant"></a> [cloudant](#module\_cloudant) | ../../modules/fscloud | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform-ibm-modules/resource-group/ibm | 1.1.0 |

### Resources

No resources.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tags"></a> [access\_tags](#input\_access\_tags) | List of access tags to be associated with the Cloudant instance | `list(string)` | `[]` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | Number of blocks of throughput units. See https://cloud.ibm.com/docs/Cloudant?topic=Cloudant-ibm-cloud-public#provisioned-throughput-capacity. | `number` | `1` | no |
| <a name="input_database_config"></a> [database\_config](#input\_database\_config) | (Optional, List) The databases with their corresponding partitioning and shards to be created in the cloudant instance | <pre>list(object({<br>    db          = string<br>    partitioned = optional(bool)<br>    shards      = optional(number)<br>  }))</pre> | `[]` | no |
| <a name="input_environment_crn"></a> [environment\_crn](#input\_environment\_crn) | CRN of the IBM Cloudant Dedicated Hardware plan instance to provision a cloudant instance | `string` | n/a | yes |
| <a name="input_existing_resource_group"></a> [existing\_resource\_group](#input\_existing\_resource\_group) | If existing resource group will be used. | `bool` | `false` | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud platform API key needed to deploy IAM enabled resources. | `string` | n/a | yes |
| <a name="input_include_data_events"></a> [include\_data\_events](#input\_include\_data\_events) | Include data event types in events sent to IBM Cloud Activity Tracker. If set to false, only management events will be sent to Activity Tracker. | `bool` | `false` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name of the Cloudant instance | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The IBM Cloud region where the Cloudant instance will be provisioned. | `string` | `"us-south"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Creates a new resource group if var.existing\_resource\_group is set to false, otherwise uses existing resource group with this name. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of resource tags to be associated to cloudant instance | `list(string)` | `[]` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_capacity"></a> [capacity](#output\_capacity) | A number of blocks of throughput units |
| <a name="output_crn"></a> [crn](#output\_crn) | CRN of the resource instance |
| <a name="output_db_map"></a> [db\_map](#output\_db\_map) | A map of the Cloudant database names created and their respective IDs |
| <a name="output_instance_guid"></a> [instance\_guid](#output\_instance\_guid) | Global identifier of the cloudant instance created |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The id of the cloudant instance created |
| <a name="output_instance_name"></a> [instance\_name](#output\_instance\_name) | Name of the cloudant instance |
| <a name="output_instance_url"></a> [instance\_url](#output\_instance\_url) | The dashboard URL to access resource |
| <a name="output_plan"></a> [plan](#output\_plan) | The plan used to create cloudant instance |
| <a name="output_private_endpoint"></a> [private\_endpoint](#output\_private\_endpoint) | The external private endpoint |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name in which resource is provisioned |
| <a name="output_resource_keys_url"></a> [resource\_keys\_url](#output\_resource\_keys\_url) | The relative path to the resource keys for the instance |
| <a name="output_state"></a> [state](#output\_state) | The current state of the instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
