# IBM Cloudant Fully Configurable Gen2

This deployable architecture provisions an IBM Cloudant Gen2 instance and supports provisioning the following resources:

- A resource group, if one is not passed in.
- An IBM Cloudant Gen2 instance
- IBM Cloudant databases
- IBM Cloudant service credentials

This solution wraps the root [`module "cloudant"`](main.tf:28) with the `standard-gen2` plan and exposes the Gen2-compatible inputs needed to configure the instance.

## Before you begin

- You need an IBM Cloud account with permissions to create Cloudant instances and resource groups.
- Gen2 Cloudant instances in this solution use the `standard-gen2` plan.
- Dedicated hardware and legacy credentials are not supported for Gen2 in the root module.
