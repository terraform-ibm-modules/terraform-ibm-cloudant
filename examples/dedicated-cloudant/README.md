# Cloudant instance and database creation on dedicated host

This example uses the IBM Cloud terraform provider to:
 - Create a new standard private Cloudant instance on the provided dedicated host in the resource group and region provided.
 - Creates a VPC and a VPE to the newly created cloudant instance
 - Create database in the newly created cloudant instance
