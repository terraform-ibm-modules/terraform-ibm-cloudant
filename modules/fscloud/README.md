# Profile for IBM Cloud Framework for Financial Services

This code is a version of the [parent root module](../../) that includes a default configuration that complies with the relevant controls from the [IBM Cloud Framework for Financial Services](https://cloud.ibm.com/docs/framework-financial-services?topic=framework-financial-services-about). See the [Example for IBM Cloud Framework for Financial Services](/examples/fscloud/) for logic that uses this module.

:exclamation: **Exception:** The Cloudant DB service is not yet Financial services validated. Therefore, the infrastructure that is deployed by this module is also not validated with the Framework for Financial Services. For more information, see the list of [Financial Services Validated services]( https://cloud.ibm.com/docs/framework-financial-services?topic=framework-financial-services-vpc-architecture-about#financial-services-validated-services).

The default values in this profile were scanned by [IBM Code Risk Analyzer (CRA)](https://cloud.ibm.com/docs/code-risk-analyzer-cli-plugin?topic=code-risk-analyzer-cli-plugin-cra-cli-plugin#terraform-command) for compliance with the IBM Cloud Framework for Financial Services profile that is specified by the IBM Security and Compliance Center. The scan passed for all applicable goals.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.56.1, < 2.0.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudant"></a> [cloudant](#module\_cloudant) | ../../ | n/a |

### Resources

No resources.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tags"></a> [access\_tags](#input\_access\_tags) | List of access tags to be associated with the Cloudant instance | `list(string)` | `[]` | no |
| <a name="input_allow_credentials"></a> [allow\_credentials](#input\_allow\_credentials) | Boolean value to allow authentication credentials. | `bool` | `true` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | Number of blocks of throughput units. See https://cloud.ibm.com/docs/Cloudant?topic=Cloudant-ibm-cloud-public#provisioned-throughput-capacity. | `number` | `1` | no |
| <a name="input_database_config"></a> [database\_config](#input\_database\_config) | (Optional, List) The databases with their corresponding partitioning and shards to be created in the cloudant instance | <pre>list(object({<br>    db          = string<br>    partitioned = optional(bool)<br>    shards      = optional(number)<br>  }))</pre> | `[]` | no |
| <a name="input_enable_cors"></a> [enable\_cors](#input\_enable\_cors) | Boolean value to enable CORS. The supported values are true and false. | `bool` | `false` | no |
| <a name="input_environment_crn"></a> [environment\_crn](#input\_environment\_crn) | CRN of the IBM Cloudant Dedicated Hardware plan instance to provision a cloudant instance | `string` | n/a | yes |
| <a name="input_include_data_events"></a> [include\_data\_events](#input\_include\_data\_events) | Include data event types in events sent to IBM Cloud Activity Tracker. If set to false, only management events will be sent to Activity Tracker. | `bool` | `false` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name of the Cloudant instance | `string` | n/a | yes |
| <a name="input_origins"></a> [origins](#input\_origins) | An array of strings that contain allowed origin domains. | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | The IBM Cloud region where the Cloudant instance will be provisioned. | `string` | `"us-south"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The Id of an existing IBM Cloud resource group where the instance will be grouped. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be associated to cloudant instance | `list(string)` | `[]` | no |

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
