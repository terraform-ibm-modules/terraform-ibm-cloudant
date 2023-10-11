# Cloudant instance, access controls, and rotation of credentials through Secret Manager

This example shows how to:
 - Create a new standard Cloudant instance in the resource group and region provided.
 - Create access group and access policy for the Cloudant instance
 - Create a serviceId associated with the access group (manager, operator role)
 - Configure a Secret Manager instance to generate and rotate the API Key associated with the serviceId
