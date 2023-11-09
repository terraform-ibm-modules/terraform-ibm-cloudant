# Financial Services Cloud profile example

An end-to-end example that uses the [Profile for IBM Cloud Framework for Financial Services](../../modules/fscloud/) to deploy a Cloudant instance.

The example uses the IBM Cloud Terraform provider to create the following infrastructure:

- A resource group, if one is not passed in.
- A dedicated cloudant instance
- A basic database in the Cloudant instance
- Creates a VPC and a VPE to the newly created cloudant instance

:exclamation: **Important:** In this example, only the Cloudant instance complies with the IBM Cloud Framework for Financial Services. Other parts of the infrastructure do not necessarily comply.

## Before you begin

* You need an IBM Cloudant Dedicated Hardware plan instance in order to provision the Cloudant instance in
