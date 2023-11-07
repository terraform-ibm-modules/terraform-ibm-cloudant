# Financial Services Cloud profile example

An end-to-end example that uses the [Profile for IBM Cloud Framework for Financial Services](../../profiles/fscloud/) to deploy a Cloudant instance.

The example uses the IBM Cloud Terraform provider to create the following infrastructure:

- A resource group, if one is not passed in.
- A cloudant instance
- A basic database in the Cloudant instance

:exclamation: **Important:** In this example, only the Cloudant instance complies with the IBM Cloud Framework for Financial Services. Other parts of the infrastructure do not necessarily comply.

## Before you begin

- You need a Hyper Protect Crypto Services instance and root key available in the region that you want to deploy your PostgreSQL database instance to.
