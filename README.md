# Cloudant Module

[![Graduated (Supported)](https://img.shields.io/badge/Status-Graduated%20(Supported)-brightgreen)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-cloudant?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-cloudant/releases/latest)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)


This module supports provisioning a instance of the IBM Cloudant service. With a Lite plan, the instance is provisioned on a multi-tenant environment. With a standard plan, the instance can be provisioned either on a multi-tenant or on a dedicated environment. For more information, see [Plans and provisioning](https://cloud.ibm.com/docs/Cloudant?topic=Cloudant-ibm-cloud-public).

<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-cloudant](#terraform-ibm-cloudant)
* [Submodules](./modules)
    * [fscloud](./modules/fscloud)
* [Examples](./examples)
    * [Basic cloudant instance and database creation](./examples/basic)
    * [Cloudant instance, access controls, and rotation of credentials through Secret Manager](./examples/complete)
    * [Financial Services Cloud profile example](./examples/fscloud)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->

## cloudant-module

### Usage

#### Usage to create a cloudant instance on a multi-tenant environment:

```hcl
module "cloudant" {
  source            = "terraform-ibm-modules/cloudant/ibm"
  version           = "X.X.X" # Replace "X.X.X" with a release version to lock into a specific release
  resource_group_id = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX"
  instance_name     = "my-cloudant-instance"
}
```

#### Usage to create a cloudant instance on a dedicated environment:

```hcl
module "cloudant" {
  source            = "terraform-ibm-modules/cloudant/ibm"
  version           = "X.X.X" # Replace "X.X.X" with a release version to lock into a specific release
  resource_group_id = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX"
  instance_name     = "dedicated-cloudant-instance"
  environment_crn   = "crn:<...>" # CRN of dedicated environment
}
```

### Required IAM access policies

You need the following permissions to run this module.

- IAM Services
    - Cloudant service
        - `Manager` service access


<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0, <1.7.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.56.1, < 2.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_cloudant.cloudant_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/cloudant) | resource |
| [ibm_cloudant_database.cloudant_database](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/cloudant_database) | resource |
| [ibm_resource_tag.access_tags](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_tag) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tags"></a> [access\_tags](#input\_access\_tags) | List of access tags to be associated with the Cloudant instance | `list(string)` | `[]` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | Number of blocks of throughput units. See https://cloud.ibm.com/docs/Cloudant?topic=Cloudant-ibm-cloud-public#provisioned-throughput-capacity. Capacity modification is not supported for lite plan. | `number` | `1` | no |
| <a name="input_database_config"></a> [database\_config](#input\_database\_config) | (Optional, List) The databases with their corresponding partitioning and shards to be created in the cloudant instance | <pre>list(object({<br>    db          = string<br>    partitioned = optional(bool)<br>    shards      = optional(number)<br>  }))</pre> | `[]` | no |
| <a name="input_environment_crn"></a> [environment\_crn](#input\_environment\_crn) | Optional CRN of the IBM Cloudant Dedicated Hardware plan instance to provision a cloudant instance | `string` | `null` | no |
| <a name="input_include_data_events"></a> [include\_data\_events](#input\_include\_data\_events) | Include data event types in events sent to IBM Cloud Activity Tracker. If set to false, only management events will be sent to Activity Tracker. | `bool` | `false` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name of the Cloudant instance | `string` | n/a | yes |
| <a name="input_legacy_credentials"></a> [legacy\_credentials](#input\_legacy\_credentials) | Use both legacy credentials, in addition to IAM credentials for authentication. If set to false, use use only IAM credentials. | `bool` | `false` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | The plan for the Cloudant instance. Standard or lite. | `string` | `"standard"` | no |
| <a name="input_region"></a> [region](#input\_region) | The IBM Cloud region where the Cloudant instance will be provisioned. | `string` | `"us-south"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The Id of an existing IBM Cloud resource group where the instance will be grouped. | `string` | n/a | yes |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | Sets the endpoint of the instance, valid values are 'public', 'private', or 'public-and-private' | `string` | `"public-and-private"` | no |
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
| <a name="output_public_endpoint"></a> [public\_endpoint](#output\_public\_endpoint) | The external public endpoint |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name in which resource is provisioned |
| <a name="output_resource_keys_url"></a> [resource\_keys\_url](#output\_resource\_keys\_url) | The relative path to the resource keys for the instance |
| <a name="output_state"></a> [state](#output\_state) | The current state of the instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
